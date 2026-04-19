import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  // MARK: - Share Extension Data Handling
  //
  // BUG FIX: Two critical timing issues with Share Extension → Flutter data flow:
  //
  // Problem 1 (Hot/Warm Start — MAIN BUG):
  // When the app is already running in the background, the Share Extension saves
  // shared URL/text to UserDefaults via App Group. However, the app had NO mechanism
  // to detect new data when returning to foreground — checkSharedData() was only
  // called in didFinishLaunchingWithOptions (cold start). The first share appeared
  // visually (new link shown) but did NOT trigger content download. The second share
  // worked because the app was already active.
  // FIX: Added applicationDidBecomeActive to check for shared data every time
  // the app returns to foreground.
  //
  // Problem 2 (Cold Start):
  // On cold start, checkSharedData() in didFinishLaunchingWithOptions fires
  // BEFORE the Flutter engine and MethodChannel handler are fully initialized.
  // Data sent via invokeMethod("onSharedText") was silently lost.
  // FIX: Added getSharedData MethodChannel handler so Flutter can actively
  // pull pending data after its own initialization completes.
  //
  // These fixes apply to ALL shared content types: URLs, plain text, media, and files.
  
  private var sharedText: [String] = []
  private var sharedMedia: [[String: Any]] = []
  
  /// Data that couldn't be delivered to Flutter yet (engine not ready on cold start)
  private var pendingSharedText: [String] = []
  private var pendingSharedMedia: [[String: Any]] = []
  
  /// Whether Flutter has signaled it's ready to receive shared data
  private var isFlutterReady = false
  
  /// Persistent reference to the MethodChannel (avoid recreating on every send)
  private var shareChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    print("🔥 AppDelegate: didFinishLaunchingWithOptions called")
    
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    // Set up MethodChannel for bidirectional communication with Flutter.
    // Must happen after GeneratedPluginRegistrant.register().
    setupMethodChannel()
    
    // Open-in / document URL when the app was not already running
    if let launchUrl = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
      queueDocumentOpened(at: launchUrl)
    }
    
    // Check for shared data on cold start.
    // Flutter is likely not ready yet, so data will be stored as pending
    // and delivered when Flutter calls getSharedData.
    checkSharedData()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - Foreground Detection (Fix for Problem 1)
  //
  // Called every time the app becomes active: returning from background,
  // after Share Extension completes, after notification tap, etc.
  // This is the PRIMARY fix for the "first share doesn't trigger download" bug.
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    print("🔥 AppDelegate: applicationDidBecomeActive — checking for shared data")
    checkSharedData()
  }
  
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("🔥 AppDelegate: URL received: \(url)")
    
    if url.absoluteString.contains("ShareMedia-") {
      print("🔥 Share Extension callback detected")
      checkSharedData()
      NotificationCenter.default.post(name: NSNotification.Name("shareDataReceived"), object: nil)
      return super.application(app, open: url, options: options)
    }
    
    // "Open in" from Files / other apps (security-scoped or inbox file URL)
    if url.isFileURL {
      queueDocumentOpened(at: url)
      checkSharedData()
      return true
    }
    
    return super.application(app, open: url, options: options)
  }
  
  // MARK: - MethodChannel Setup (Fix for Problem 2)
  //
  // Sets up a persistent MethodChannel with a handler for getSharedData,
  // allowing Flutter to actively pull shared data after its initialization.
  // This solves the cold start timing issue.
  private func setupMethodChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("🔥 setupMethodChannel: FlutterViewController not found")
      return
    }
    
    shareChannel = FlutterMethodChannel(
      name: "com.summify.share",
      binaryMessenger: controller.binaryMessenger
    )
    
    shareChannel?.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      if call.method == "getSharedData" {
        print("🔥 AppDelegate: Flutter called getSharedData — marking as ready")
        self.isFlutterReady = true
        
        // Load any fresh data from UserDefaults
        self.loadSharedDataFromUserDefaults()
        
        // Return pending text (URLs and plain text)
        if !self.pendingSharedText.isEmpty {
          print("🔥 Returning \(self.pendingSharedText.count) pending text items to Flutter")
          let data = self.pendingSharedText
          self.pendingSharedText.removeAll()
          result(data)
        }
        // Return pending media/files
        else if !self.pendingSharedMedia.isEmpty {
          print("🔥 Returning \(self.pendingSharedMedia.count) pending media items to Flutter")
          let data = self.pendingSharedMedia
          self.pendingSharedMedia.removeAll()
          result(data)
        }
        else {
          result(nil)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  // MARK: - UserDefaults Data Loading
  
  /// Reads shared data from UserDefaults (App Group) into pending arrays.
  /// Clears UserDefaults after reading to prevent duplicate processing.
  private func loadSharedDataFromUserDefaults() {
    guard let appGroupId = Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String else {
      print("🔥 No AppGroupId found in Info.plist")
      return
    }
    
    let userDefaults = UserDefaults(suiteName: appGroupId)
    
    // Check for shared text/URL (stored as [String] by ShareViewController)
    if let sharedArray = userDefaults?.object(forKey: "ShareKey") as? [String] {
      print("🔥 Found shared text/URLs in UserDefaults: \(sharedArray)")
      self.pendingSharedText.append(contentsOf: sharedArray)
      userDefaults?.removeObject(forKey: "ShareKey")
      userDefaults?.synchronize()
    }
    
    // Check for shared media/files (stored as encoded Data by ShareViewController)
    if let sharedData = userDefaults?.object(forKey: "ShareKey") as? Data {
      print("🔥 Found shared media data in UserDefaults")
      do {
        if let mediaArray = try JSONSerialization.jsonObject(with: sharedData, options: []) as? [[String: Any]] {
          print("🔥 Parsed shared media: \(mediaArray)")
          self.pendingSharedMedia.append(contentsOf: mediaArray)
          userDefaults?.removeObject(forKey: "ShareKey")
          userDefaults?.synchronize()
        }
      } catch {
        print("🔥 Error parsing shared media: \(error)")
      }
    }
  }
  
  /// Copies a locally opened file into Caches and queues the same payload shape as the Share Extension.
  private func queueDocumentOpened(at url: URL) {
    guard url.isFileURL else { return }
    
    let accessed = url.startAccessingSecurityScopedResource()
    defer {
      if accessed {
        url.stopAccessingSecurityScopedResource()
      }
    }
    
    let fileManager = FileManager.default
    guard let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      print("🔥 queueDocumentOpened: no caches directory")
      return
    }
    
    let baseName = url.lastPathComponent
    let safeName = baseName.isEmpty ? "document.bin" : baseName
    let dest = caches.appendingPathComponent("opened_\(UUID().uuidString.prefix(8))_\(safeName)")
    
    do {
      try fileManager.copyItem(at: url, to: dest)
      let item: [String: Any] = ["path": dest.path, "type": 2]
      pendingSharedMedia.append(item)
      print("🔥 Queued opened document at \(dest.path)")
    } catch {
      print("🔥 queueDocumentOpened: copy failed: \(error)")
    }
  }
  
  /// Loads data from UserDefaults, then sends to Flutter if ready.
  /// If Flutter isn't ready, data stays in pending arrays for later delivery.
  private func checkSharedData() {
    loadSharedDataFromUserDefaults()
    
    if isFlutterReady {
      sendSharedDataToFlutter()
    } else if !pendingSharedText.isEmpty || !pendingSharedMedia.isEmpty {
      print("🔥 Flutter not ready — \(pendingSharedText.count) text, \(pendingSharedMedia.count) media items pending")
    }
  }
  
  /// Pushes pending shared data to Flutter via MethodChannel.
  private func sendSharedDataToFlutter() {
    guard let channel = shareChannel else {
      print("🔥 MethodChannel not set up yet, keeping data as pending")
      return
    }
    
    if !pendingSharedText.isEmpty {
      let dataToSend = pendingSharedText
      pendingSharedText.removeAll()
      print("🔥 Pushing \(dataToSend.count) text items to Flutter: \(dataToSend)")
      channel.invokeMethod("onSharedText", arguments: dataToSend)
    }
    
    if !pendingSharedMedia.isEmpty {
      let dataToSend = pendingSharedMedia
      pendingSharedMedia.removeAll()
      print("🔥 Pushing \(dataToSend.count) media items to Flutter: \(dataToSend)")
      channel.invokeMethod("onSharedMedia", arguments: dataToSend)
    }
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }
  
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    print("🔥 AppDelegate: Notification tapped with userInfo: \(userInfo)")
    
    if let shareKey = userInfo["shareKey"] as? String, shareKey == "ShareKey" {
      print("🔥 Share Extension notification tapped — checking for shared data")
      checkSharedData()
    }
    
    completionHandler()
  }
}

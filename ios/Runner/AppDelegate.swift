import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  private var sharedText: [String] = []
  private var sharedMedia: [[String: Any]] = []
  
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
    
    // Check for shared data from Share Extension on cold start
    checkSharedData()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("🔥 AppDelegate: URL received: \(url)")
    print("🔥 URL scheme: \(url.scheme ?? "no scheme")")
    print("🔥 URL host: \(url.host ?? "no host")")
    print("🔥 URL absoluteString: \(url.absoluteString)")
    
    // Check if this is a share callback from Share Extension
    if url.absoluteString.contains("ShareMedia-") {
      print("🔥 Share Extension callback detected")
      checkSharedData()
      
      // Send data to Flutter via app_links
      NotificationCenter.default.post(name: NSNotification.Name("shareDataReceived"), object: nil)
    }
    
    return super.application(app, open: url, options: options)
  }
  
  private func checkSharedData() {
    guard let appGroupId = Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String else {
      print("🔥 No AppGroupId found in Info.plist")
      return
    }
    
    print("🔥 AppGroupId: \(appGroupId)")
    let userDefaults = UserDefaults(suiteName: appGroupId)
    
    // Check for shared text/URL
    if let sharedArray = userDefaults?.object(forKey: "ShareKey") as? [String] {
      print("🔥 Found shared text/URLs: \(sharedArray)")
      self.sharedText = sharedArray
      
      // Clear the shared data
      userDefaults?.removeObject(forKey: "ShareKey")
      userDefaults?.synchronize()
      
      // Send to Flutter
      sendSharedDataToFlutter()
    }
    
    // Check for shared media/files
    if let sharedData = userDefaults?.object(forKey: "ShareKey") as? Data {
      print("🔥 Found shared media data")
      do {
        if let mediaArray = try JSONSerialization.jsonObject(with: sharedData, options: []) as? [[String: Any]] {
          print("🔥 Parsed shared media: \(mediaArray)")
          self.sharedMedia = mediaArray
          
          // Clear the shared data
          userDefaults?.removeObject(forKey: "ShareKey")
          userDefaults?.synchronize()
          
          // Send to Flutter
          sendSharedDataToFlutter()
        }
      } catch {
        print("🔥 Error parsing shared media: \(error)")
      }
    }
  }
  
  private func sendSharedDataToFlutter() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("🔥 FlutterViewController not found")
      return
    }
    
    let channel = FlutterMethodChannel(name: "com.summify.share", binaryMessenger: controller.binaryMessenger)
    
    if !sharedText.isEmpty {
      print("🔥 Sending shared text to Flutter: \(sharedText)")
      channel.invokeMethod("onSharedText", arguments: sharedText)
      sharedText.removeAll()
    }
    
    if !sharedMedia.isEmpty {
      print("🔥 Sending shared media to Flutter: \(sharedMedia)")
      channel.invokeMethod("onSharedMedia", arguments: sharedMedia)
      sharedMedia.removeAll()
    }
  }
}

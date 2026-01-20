import UIKit
import MobileCoreServices
import Photos
import AVFoundation
import UserNotifications

class ShareViewController: UIViewController {
    var hostAppBundleIdentifier = ""
    var appGroupId = ""
    let sharedKey = "ShareKey"
    var sharedMedia: [SharedMediaFile] = []
    var sharedText: [String] = []
    let imageContentType = kUTTypeImage as String
    let videoContentType = kUTTypeMovie as String
    let textContentType = kUTTypeText as String
    let urlContentType = kUTTypeURL as String
    let fileURLType = kUTTypeFileURL as String
  
    private func loadIds() {
        // loading Share extension App Id
        let shareExtensionAppBundleIdentifier = Bundle.main.bundleIdentifier!

        // convert ShareExtension id to host app id
        // By default it is removed the last part of id after the last point
        // For example: com.test.ShareExtension -> com.test
        if let lastIndexOfPoint = shareExtensionAppBundleIdentifier.lastIndex(of: ".") {
            hostAppBundleIdentifier = String(shareExtensionAppBundleIdentifier[..<lastIndexOfPoint])
        }

        // loading custom AppGroupId from Build Settings or use group.<hostAppBundleIdentifier>
        appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(hostAppBundleIdentifier)"
        
        print("🔥 Share Extension: Bundle ID: \(shareExtensionAppBundleIdentifier)")
        print("🔥 Share Extension: Host App Bundle ID: \(hostAppBundleIdentifier)")
        print("🔥 Share Extension: App Group ID: \(appGroupId)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the view to avoid showing UI
        self.view.alpha = 0
        self.view.backgroundColor = .clear

        // load group and app id from build info
        loadIds()
        
        // Process shared content immediately
        processSharedContent()
    }
    
    private func processSharedContent() {
        print("🔥 Share Extension: Processing shared content")
        
        guard let extensionContext = extensionContext,
              let inputItems = extensionContext.inputItems as? [NSExtensionItem] else {
            print("🔥 Share Extension: No input items found")
            dismissWithError()
            return
        }
        
        print("🔥 Share Extension: Found \(inputItems.count) input items")
        
        guard let content = inputItems.first else {
            print("🔥 Share Extension: No content in input items")
            dismissWithError()
            return
        }
        
        guard let attachments = content.attachments else {
            print("🔥 Share Extension: No attachments found")
            dismissWithError()
            return
        }
        
        print("🔥 Share Extension: Found \(attachments.count) attachments")
        
        for (index, attachment) in attachments.enumerated() {
            print("🔥 Share Extension: Processing attachment \(index)")
            
            if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
                print("🔥 Share Extension: Detected URL type")
                handleUrl(content: content, attachment: attachment, index: index)
            } else if attachment.hasItemConformingToTypeIdentifier(textContentType) {
                print("🔥 Share Extension: Detected text type")
                handleText(content: content, attachment: attachment, index: index)
            } else if attachment.hasItemConformingToTypeIdentifier(imageContentType) {
                print("🔥 Share Extension: Detected image type")
                handleImages(content: content, attachment: attachment, index: index)
            } else if attachment.hasItemConformingToTypeIdentifier(videoContentType) {
                print("🔥 Share Extension: Detected video type")
                handleVideos(content: content, attachment: attachment, index: index)
            } else if attachment.hasItemConformingToTypeIdentifier(fileURLType) {
                print("🔥 Share Extension: Detected file type")
                handleFiles(content: content, attachment: attachment, index: index)
            } else {
                print("🔥 Share Extension: Unknown attachment type")
            }
        }
    }

    private func handleText(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in

            if error == nil, let item = data as? String, let this = self {
                print("🔥 Share Extension: Loaded text item: \(item)")
                this.sharedText.append(item)

                // If this is the last item, save data in userDefaults and show notification
                if index == (content.attachments?.count)! - 1 {
                    print("🔥 Share Extension: Saving \(this.sharedText.count) text items to UserDefaults")
                    let userDefaults = UserDefaults(suiteName: this.appGroupId)
                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    print("🔥 Share Extension: Text saved successfully")
                    
                    // Show notification with first text item
                    let displayText = this.sharedText.first ?? "text content"
                    this.showNotificationAndComplete(type: .text, sharedContent: displayText)
                }

            } else {
                print("🔥 Share Extension: ERROR loading text - \(error?.localizedDescription ?? "unknown error")")
                self?.dismissWithError()
            }
        }
    }

    private func handleUrl(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in

            guard let this = self else { return }
            
            if let error = error {
                print("🔥 Share Extension: ERROR loading URL - \(error.localizedDescription)")
                this.dismissWithError()
                return
            }
            
            // Try to get URL - it can be either URL object or String
            var urlString: String? = nil
            
            if let url = data as? URL {
                print("🔥 Share Extension: Loaded URL object: \(url.absoluteString)")
                urlString = url.absoluteString
            } else if let string = data as? String {
                print("🔥 Share Extension: Loaded URL as string: \(string)")
                urlString = string
            } else {
                print("🔥 Share Extension: ERROR - Data is neither URL nor String, type: \(type(of: data))")
                this.dismissWithError()
                return
            }
            
            guard let finalUrl = urlString else {
                print("🔥 Share Extension: ERROR - Could not extract URL string")
                this.dismissWithError()
                return
            }
            
            this.sharedText.append(finalUrl)

            // If this is the last item, save data in userDefaults and show notification
            if index == (content.attachments?.count)! - 1 {
                print("🔥 Share Extension: Saving URL to UserDefaults: \(finalUrl)")
                guard let userDefaults = UserDefaults(suiteName: this.appGroupId) else {
                    print("🔥 Share Extension: ERROR - Could not create UserDefaults with suite: \(this.appGroupId)")
                    this.dismissWithError()
                    return
                }
                
                userDefaults.set(this.sharedText, forKey: this.sharedKey)
                userDefaults.synchronize()
                
                // Verify the data was saved
                if let savedData = userDefaults.array(forKey: this.sharedKey) as? [String] {
                    print("🔥 Share Extension: URL saved successfully, verified: \(savedData)")
                } else {
                    print("🔥 Share Extension: WARNING - Could not verify saved data")
                }
                
                this.showNotificationAndComplete(type: .text, sharedContent: finalUrl)
            }
        }
    }

    private func handleImages(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) { [weak self] data, error in

            if error == nil, let url = data as? URL, let this = self {

                // Always copy
                let fileName = this.getFileName(from: url, type: .image)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: this.appGroupId)!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    this.sharedMedia.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .image))
                }

                // If this is the last item, save data in userDefaults and show notification
                if index == (content.attachments?.count)! - 1 {
                    let userDefaults = UserDefaults(suiteName: this.appGroupId)
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    
                    let mediaCount = this.sharedMedia.count
                    let displayText = mediaCount == 1 ? "1 image" : "\(mediaCount) images"
                    this.showNotificationAndComplete(type: .media, sharedContent: displayText)
                }

            } else {
                self?.dismissWithError()
            }
        }
    }

    private func handleVideos(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: videoContentType, options: nil) { [weak self] data, error in

            if error == nil, let url = data as? URL, let this = self {

                // Always copy
                let fileName = this.getFileName(from: url, type: .video)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: this.appGroupId)!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    guard let sharedFile = this.getSharedMediaFile(forVideo: newPath) else {
                        return
                    }
                    this.sharedMedia.append(sharedFile)
                }

                // If this is the last item, save data in userDefaults and show notification
                if index == (content.attachments?.count)! - 1 {
                    let userDefaults = UserDefaults(suiteName: this.appGroupId)
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    
                    let mediaCount = this.sharedMedia.count
                    let displayText = mediaCount == 1 ? "1 video" : "\(mediaCount) videos"
                    this.showNotificationAndComplete(type: .media, sharedContent: displayText)
                }

            } else {
                self?.dismissWithError()
            }
        }
    }

    private func handleFiles(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: fileURLType, options: nil) { [weak self] data, error in

            if error == nil, let url = data as? URL, let this = self {

                // Always copy
                let fileName = this.getFileName(from: url, type: .file)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: this.appGroupId)!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    this.sharedMedia.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .file))
                }

                if index == (content.attachments?.count)! - 1 {
                    let userDefaults = UserDefaults(suiteName: this.appGroupId)
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    
                    let mediaCount = this.sharedMedia.count
                    let displayText = mediaCount == 1 ? fileName : "\(mediaCount) files"
                    this.showNotificationAndComplete(type: .file, sharedContent: displayText)
                }

            } else {
                self?.dismissWithError()
            }
        }
    }

    private func dismissWithError() {
        print("[ERROR] Error loading data!")
        let alert = UIAlertController(title: "Error", message: "Error loading data", preferredStyle: .alert)

        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func showNotificationAndComplete(type: RedirectType, sharedContent: String) {
        print("🔥 Share Extension: Showing notification for: \(sharedContent)")
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let this = self else { return }
            
            if let error = error {
                print("🔥 Share Extension: Notification authorization error: \(error.localizedDescription)")
                this.completeExtension()
                return
            }
            
            guard granted else {
                print("🔥 Share Extension: Notification permission denied")
                this.completeExtension()
                return
            }
            
            print("🔥 Share Extension: Notification permission granted")
            
            let content = UNMutableNotificationContent()
            content.title = "Content Shared to Summify"
            
            // Truncate long URLs for better display
            let displayContent = sharedContent.count > 100 ? String(sharedContent.prefix(97)) + "..." : sharedContent
            content.body = "Tap to open and process: \(displayContent)"
            content.sound = .default
            content.badge = 1
            content.userInfo = ["shareType": "\(type)", "shareKey": this.sharedKey]
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil // Show immediately
            )
            
            center.add(request) { error in
                if let error = error {
                    print("🔥 Share Extension: Error showing notification: \(error.localizedDescription)")
                } else {
                    print("🔥 Share Extension: Notification shown successfully")
                }
                this.completeExtension()
            }
        }
    }
    
    private func completeExtension() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: { _ in
            print("🔥 Share Extension: Extension request completed")
        })
    }

    enum RedirectType {
        case media
        case text
        case file
    }

    func getExtension(from url: URL, type: SharedMediaType) -> String {
        let parts = url.lastPathComponent.components(separatedBy: ".")
        var ex: String? = nil
        if (parts.count > 1) {
            ex = parts.last
        }

        if (ex == nil) {
            switch type {
            case .image:
                ex = "PNG"
            case .video:
                ex = "MP4"
            case .file:
                ex = "TXT"
            }
        }
        return ex ?? "Unknown"
    }

    func getFileName(from url: URL, type: SharedMediaType) -> String {
        var name = url.lastPathComponent

        if (name.isEmpty) {
            name = UUID().uuidString + "." + getExtension(from: url, type: type)
        }

        return name
    }

    func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }

    private func getSharedMediaFile(forVideo: URL) -> SharedMediaFile? {
        let asset = AVAsset(url: forVideo)
        let duration = (CMTimeGetSeconds(asset.duration) * 1000).rounded()
        let thumbnailPath = getThumbnailPath(for: forVideo)

        if FileManager.default.fileExists(atPath: thumbnailPath.path) {
            return SharedMediaFile(path: forVideo.absoluteString, thumbnail: thumbnailPath.absoluteString, duration: duration, type: .video)
        }

        var saved = false
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize =  CGSize(width: 360, height: 360)
        do {
            let img = try assetImgGenerate.copyCGImage(at: CMTimeMakeWithSeconds(600, preferredTimescale: Int32(1.0)), actualTime: nil)
            try UIImage.pngData(UIImage(cgImage: img))()?.write(to: thumbnailPath)
            saved = true
        } catch {
            saved = false
        }

        return saved ? SharedMediaFile(path: forVideo.absoluteString, thumbnail: thumbnailPath.absoluteString, duration: duration, type: .video) : nil
    }

    private func getThumbnailPath(for url: URL) -> URL {
        let fileName = Data(url.lastPathComponent.utf8).base64EncodedString().replacingOccurrences(of: "==", with: "")
        let path = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)!
            .appendingPathComponent("\(fileName).jpg")
        return path
    }

    class SharedMediaFile: Codable {
        var path: String
        var thumbnail: String?
        var duration: Double?
        var type: SharedMediaType

        init(path: String, thumbnail: String?, duration: Double?, type: SharedMediaType) {
            self.path = path
            self.thumbnail = thumbnail
            self.duration = duration
            self.type = type
        }

        func toString() {
            print("[SharedMediaFile] \n\tpath: \(self.path)\n\tthumbnail: \(self.thumbnail)\n\tduration: \(self.duration)\n\ttype: \(self.type)")
        }
    }

    enum SharedMediaType: Int, Codable {
        case image
        case video
        case file
    }

    func toData(data: [SharedMediaFile]) -> Data {
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData ?? Data()
    }
}

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}

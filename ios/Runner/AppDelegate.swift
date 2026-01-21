import UIKit
import Flutter
import flutter_local_notifications
import NaturalLanguage

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  private var sharedText: [String] = []
  private var sharedMedia: [[String: Any]] = []
  private let knowledgeCardsExtractor = KnowledgeCardsExtractor()
  
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
    
    // Setup Knowledge Cards Method Channel
    setupKnowledgeCardsChannel()
    
    // Check for shared data from Share Extension on cold start
    checkSharedData()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupKnowledgeCardsChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("🧠 KnowledgeCards: FlutterViewController not found")
      return
    }
    
    let channel = FlutterMethodChannel(
      name: "knowledge_cards_extractor",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      switch call.method {
      case "isAppleIntelligenceAvailable":
        let isAvailable = AppleIntelligenceChecker.isAvailable()
        print("🧠 KnowledgeCards: isAvailable = \(isAvailable)")
        result(isAvailable)
        
      case "getDeviceInfo":
        let deviceInfo = AppleIntelligenceChecker.getDeviceInfo()
        print("🧠 KnowledgeCards: deviceInfo = \(deviceInfo)")
        result(deviceInfo)
        
      case "extractKnowledgeCards":
        guard let args = call.arguments as? [String: Any],
              let text = args["text"] as? String else {
          result(FlutterError(
            code: "INVALID_ARGUMENTS",
            message: "Text parameter required",
            details: nil
          ))
          return
        }
        
        let numCards = args["numCards"] as? Int ?? 5
        
        print("🧠 KnowledgeCards: Extracting \(numCards) cards from text of length \(text.count)")
        
        self.knowledgeCardsExtractor.extractKnowledgeCards(
          from: text,
          numCards: numCards
        ) { cards, error in
          if let error = error {
            print("🧠 KnowledgeCards: Error - \(error.localizedDescription)")
            result(FlutterError(
              code: "EXTRACTION_ERROR",
              message: error.localizedDescription,
              details: nil
            ))
          } else {
            print("🧠 KnowledgeCards: Successfully extracted cards")
            result(cards)
          }
        }
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }
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

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Show notification even when app is in foreground
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
    
    // Check if this is from Share Extension
    if let shareKey = userInfo["shareKey"] as? String, shareKey == "ShareKey" {
      print("🔥 AppDelegate: Share Extension notification detected")
      
      // Check shared data when notification is tapped
      checkSharedData()
    }
    
    completionHandler()
  }
}

// MARK: - Apple Intelligence Checker
@objc class AppleIntelligenceChecker: NSObject {
    
    @objc static func isAvailable() -> Bool {
        guard #available(iOS 18.1, *) else {
            print("🧠 Apple Intelligence: iOS version < 18.1")
            return false
        }
        
        let deviceSupported = checkDeviceSupport()
        print("🧠 Apple Intelligence: Device supported: \(deviceSupported)")
        
        return deviceSupported
    }
    
    @objc static func getDeviceInfo() -> [String: Any] {
        let isSupported = isAvailable()
        let deviceModel = getDeviceModel()
        let osVersion = UIDevice.current.systemVersion
        
        var info: [String: Any] = [
            "supportsAppleIntelligence": isSupported,
            "deviceModel": deviceModel,
            "osVersion": osVersion
        ]
        
        if !isSupported {
            info["unsupportedReason"] = getUnsupportedReason()
        }
        
        return info
    }
    
    private static func checkDeviceSupport() -> Bool {
        let deviceModel = getDeviceModelIdentifier()
        
        if deviceModel.hasPrefix("iPhone16,") {
            return true
        }
        
        if deviceModel.hasPrefix("iPhone17,") {
            return true
        }
        
        if deviceModel.hasPrefix("iPad") {
            if deviceModel.hasPrefix("iPad13,") || 
               deviceModel.hasPrefix("iPad14,") ||
               deviceModel.hasPrefix("iPad15,") {
                return true
            }
        }
        
        #if targetEnvironment(macCatalyst)
        if isAppleSilicon() {
            return true
        }
        #endif
        
        return false
    }
    
    private static func getDeviceModel() -> String {
        let identifier = getDeviceModelIdentifier()
        
        if identifier.hasPrefix("iPhone16,1") { return "iPhone 15 Pro" }
        if identifier.hasPrefix("iPhone16,2") { return "iPhone 15 Pro Max" }
        if identifier.hasPrefix("iPhone17,1") { return "iPhone 16 Pro" }
        if identifier.hasPrefix("iPhone17,2") { return "iPhone 16 Pro Max" }
        if identifier.hasPrefix("iPhone17,3") { return "iPhone 16" }
        if identifier.hasPrefix("iPhone17,4") { return "iPhone 16 Plus" }
        
        if identifier.hasPrefix("iPad13,") { return "iPad Pro/Air (M1)" }
        if identifier.hasPrefix("iPad14,") { return "iPad Pro/Air (M2)" }
        if identifier.hasPrefix("iPad15,") { return "iPad Pro/Air (M3)" }
        
        #if targetEnvironment(macCatalyst)
        return "Mac (Apple Silicon)"
        #endif
        
        return identifier
    }
    
    private static func getDeviceModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    #if targetEnvironment(macCatalyst)
    private static func isAppleSilicon() -> Bool {
        #if arch(arm64)
        return true
        #else
        return false
        #endif
    }
    #endif
    
    private static func getUnsupportedReason() -> String {
        if #available(iOS 18.1, *) {
            return "Device hardware does not support Apple Intelligence"
        } else {
            return "iOS 18.1 or later required"
        }
    }
}

// MARK: - Knowledge Cards Extractor
@objc class KnowledgeCardsExtractor: NSObject {
    
    private let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass])
    
    @objc func extractKnowledgeCards(
        from text: String,
        numCards: Int = 5,
        completion: @escaping ([String: Any]?, Error?) -> Void
    ) {
        guard #available(iOS 18.0, *) else {
            completion(nil, NSError(
                domain: "KnowledgeCards",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "iOS 18+ required"]
            ))
            return
        }
        
        guard !text.isEmpty else {
            completion(nil, NSError(
                domain: "KnowledgeCards",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Text is empty"]
            ))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let sentences = self.extractSentences(from: text)
                let keyTerms = self.extractKeyTerms(from: text)
                let rankedSentences = self.rankSentences(sentences, in: text)
                let cards = self.generateCards(
                    from: rankedSentences,
                    keyTerms: keyTerms,
                    maxCards: numCards
                )
                
                let result: [String: Any] = [
                    "cards": cards.map { $0.toDictionary() },
                    "generated_at": ISO8601DateFormatter().string(from: Date()),
                    "total_cards": cards.count
                ]
                
                DispatchQueue.main.async {
                    completion(result, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    private func extractSentences(from text: String) -> [String] {
        var sentences: [String] = []
        
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }
        
        return sentences
    }
    
    private func extractKeyTerms(from text: String) -> [KeyTerm] {
        var terms: [KeyTerm] = []
        var termSet = Set<String>()
        
        tagger.string = text
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: options
        ) { tag, range in
            if let tag = tag {
                let term = String(text[range])
                let lowercaseTerm = term.lowercased()
                
                if !termSet.contains(lowercaseTerm) && term.count > 2 {
                    let type = self.mapTagToCardType(tag)
                    terms.append(KeyTerm(text: term, type: type, context: self.getContext(for: range, in: text)))
                    termSet.insert(lowercaseTerm)
                }
            }
            return true
        }
        
        return terms
    }
    
    private func getContext(for range: Range<String.Index>, in text: String) -> String {
        let contextRange = 50
        
        let startIndex = text.index(range.lowerBound, offsetBy: -contextRange, limitedBy: text.startIndex) ?? text.startIndex
        let endIndex = text.index(range.upperBound, offsetBy: contextRange, limitedBy: text.endIndex) ?? text.endIndex
        
        return String(text[startIndex..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func rankSentences(_ sentences: [String], in text: String) -> [RankedSentence] {
        let totalSentences = sentences.count
        
        return sentences.enumerated().map { index, sentence in
            var score: Double = 0.0
            
            let wordCount = sentence.components(separatedBy: .whitespaces).count
            if wordCount >= 15 && wordCount <= 30 {
                score += 0.3
            } else if wordCount >= 10 && wordCount <= 40 {
                score += 0.15
            }
            
            let keywords = ["important", "key", "main", "essential", "crucial", 
                          "therefore", "thus", "conclude", "summary", "significant"]
            for keyword in keywords {
                if sentence.lowercased().contains(keyword) {
                    score += 0.2
                    break
                }
            }
            
            if index < 3 {
                score += 0.25
            } else if index >= totalSentences - 3 {
                score += 0.2
            }
            
            if sentence.range(of: "\\d+", options: .regularExpression) != nil {
                score += 0.15
            }
            
            let actionVerbs = ["start", "begin", "create", "make", "do", "try", "use", "apply"]
            for verb in actionVerbs {
                if sentence.lowercased().contains(verb) {
                    score += 0.1
                    break
                }
            }
            
            return RankedSentence(text: sentence, score: score, position: index, wordCount: wordCount)
        }.sorted { $0.score > $1.score }
    }
    
    private func generateCards(
        from sentences: [RankedSentence],
        keyTerms: [KeyTerm],
        maxCards: Int
    ) -> [KnowledgeCard] {
        var cards: [KnowledgeCard] = []
        var usedSentences = Set<String>()
        
        let thesisCount = max(2, maxCards / 2)
        let termCount = max(1, maxCards / 4)
        let conclusionCount = max(1, maxCards / 5)
        let insightCount = maxCards - thesisCount - termCount - conclusionCount
        
        let thesisSentences = sentences.filter { $0.wordCount >= 10 }.prefix(thesisCount)
        for sentence in thesisSentences {
            cards.append(KnowledgeCard(
                id: UUID().uuidString,
                type: .thesis,
                title: generateTitle(from: sentence.text),
                content: sentence.text,
                explanation: nil,
                relevanceScore: sentence.score
            ))
            usedSentences.insert(sentence.text)
        }
        
        for term in keyTerms.prefix(termCount) {
            let definition = generateDefinition(for: term)
            cards.append(KnowledgeCard(
                id: UUID().uuidString,
                type: .term,
                title: term.text,
                content: definition,
                explanation: nil,
                relevanceScore: 0.85
            ))
        }
        
        let conclusionSentences = sentences.filter { 
            $0.position >= sentences.count - 5 && !usedSentences.contains($0.text) 
        }.prefix(conclusionCount)
        
        for sentence in conclusionSentences {
            cards.append(KnowledgeCard(
                id: UUID().uuidString,
                type: .conclusion,
                title: generateTitle(from: sentence.text),
                content: sentence.text,
                explanation: nil,
                relevanceScore: sentence.score * 0.9
            ))
            usedSentences.insert(sentence.text)
        }
        
        let insightSentences = sentences.filter { sentence in
            !usedSentences.contains(sentence.text) &&
            (sentence.text.lowercased().contains("start") ||
             sentence.text.lowercased().contains("try") ||
             sentence.text.lowercased().contains("should") ||
             sentence.text.lowercased().contains("can"))
        }.prefix(insightCount)
        
        for sentence in insightSentences {
            cards.append(KnowledgeCard(
                id: UUID().uuidString,
                type: .insight,
                title: generateTitle(from: sentence.text),
                content: sentence.text,
                explanation: nil,
                relevanceScore: sentence.score * 0.95
            ))
        }
        
        return Array(cards.prefix(maxCards))
    }
    
    private func generateTitle(from sentence: String) -> String {
        let words = sentence.components(separatedBy: .whitespaces)
        let titleWords = words.prefix(min(10, words.count))
        var title = titleWords.joined(separator: " ")
        
        title = title.trimmingCharacters(in: CharacterSet(charactersIn: ".,;:!?"))
        
        if title.count > 80 {
            title = String(title.prefix(77)) + "..."
        }
        
        return title
    }
    
    private func generateDefinition(for term: KeyTerm) -> String {
        if !term.context.isEmpty {
            return term.context
        }
        
        return "\(term.text) - key concept mentioned in the text"
    }
    
    private func mapTagToCardType(_ tag: NLTag) -> KnowledgeCardType {
        switch tag {
        case .personalName, .placeName, .organizationName:
            return .term
        default:
            return .insight
        }
    }
}

// MARK: - Supporting Types
struct KeyTerm {
    let text: String
    let type: KnowledgeCardType
    let context: String
}

struct RankedSentence {
    let text: String
    let score: Double
    let position: Int
    let wordCount: Int
}

struct KnowledgeCard {
    let id: String
    let type: KnowledgeCardType
    let title: String
    let content: String
    let explanation: String?
    let relevanceScore: Double
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "type": type.rawValue,
            "title": title,
            "content": content,
            "relevance_score": relevanceScore
        ]
        
        if let explanation = explanation {
            dict["explanation"] = explanation
        }
        
        return dict
    }
}

enum KnowledgeCardType: String {
    case thesis
    case term
    case conclusion
    case insight
}

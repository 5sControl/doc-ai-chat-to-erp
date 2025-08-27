//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by mac on 4/14/25.
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    // https://diamantidis.github.io/2020/01/19/access-webpage-properties-from-ios-share-extension
    private func accessWebpageProperties(extensionItem: NSExtensionItem) {
        let propertyListType = UTType.propertyList.identifier // → "com.apple.property-list"

        for attachment in extensionItem.attachments ?? [] {
            if attachment.hasItemConformingToTypeIdentifier(propertyListType) {
                attachment.loadItem(forTypeIdentifier: propertyListType, options: nil) { item, error in
                    guard let dictionary = item as? NSDictionary,
                          let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                          let title = results["title"] as? String else {
                        return
                    }

                    print("title: \(title)")
                }
            }
        }
    }

}

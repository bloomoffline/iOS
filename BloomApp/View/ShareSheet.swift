//
//  ShareSheet.swift
//  BloomApp
//
//  
//

import SwiftUI
import UIKit
import Logging

fileprivate let log = Logger(label: "BloomApp.ShareSheet")

struct ShareSheet: SimpleUIViewControllerRepresentable {
    let items: [Any]
    var onDismiss: (() -> Void)? = nil
    
    func makeUIViewController(coordinator: ()) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.completionWithItemsHandler = { _, _, _, error in
            if let error = error {
                log.error("Error after completing share sheet: \(error)")
                return
            }
            onDismiss?()
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Do nothing
    }
}

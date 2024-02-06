//
//  URLUtils.swift
//  BloomApp
//
//  
//

import Foundation
import MobileCoreServices

extension URL {
    var mimeType: String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, pathExtension as NSString, nil),
           let mt = UTTypeCopyPreferredTagWithClass(uti.takeRetainedValue(), kUTTagClassMIMEType) {
            return mt.takeRetainedValue() as String
        }
        return "application/octet-stream"
    }
    
    var isBloomSchemed: Bool {
        scheme == "bloomoffline"
    }
    var BloomAttachmentURL: URL? {
        // bloomoffline:///attachment/a/b.txt refers to <Documents>/Attachments/a/b.txt
        
        if isBloomSchemed && pathComponents[..<2] == ["/", "attachment"] {
            return persistenceFileURL(path: "Attachments/\(pathComponents[2...].joined(separator: "/"))")
        } else {
            return nil
        }
    }
    var smartResolved: URL {
        BloomAttachmentURL ?? self
    }
    
    func smartCheckResourceIsReachable() throws -> Bool {
        try smartResolved.checkResourceIsReachable()
    }
}

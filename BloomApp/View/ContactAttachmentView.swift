//
//  ContactAttachmentView.swift
//  BloomApp
//
// 
//

import Bloom
import SwiftUI

struct ContactAttachmentView: View {
    let attachment: ChatAttachment
    
    var body: some View {
        QuickLookAttachmentView(attachment: attachment) {
            HStack {
                Image(systemName: "person.fill")
                Text(attachment.name)
            }
        }
    }
}

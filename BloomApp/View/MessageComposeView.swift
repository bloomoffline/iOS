//
//  MessageComposeView.swift
//  BloomApp
//
//  
//

import Bloom
import Contacts
import Logging
import SwiftUI
import SwiftUIKit

fileprivate let log = Logger(label: "BloomApp.MessageComposeView")

/// The compression algorithm used for encoding.
fileprivate let compression: ChatAttachment.Compression = .lzfse

struct MessageComposeView: View {
    let channel: ChatChannel?
    let controller: ChatController
    @Binding var replyingToMessageId: UUID?
    
    @EnvironmentObject private var messages: Messages
    @EnvironmentObject private var network: Network
    @State private var draft: String = ""
    @State private var draftAttachments: [DraftAttachment] = []
    @State private var attachmentActionSheetShown: Bool = false
    @State private var attachmentFilePickerShown: Bool = false
    @State private var attachmentContactPickerShown: Bool = false
    @State private var attachmentImagePickerShown: Bool = false
    @State private var attachmentImagePickerStyle: ImagePicker.SourceType = .photoLibrary
    
    private enum DraftAttachment {
        case file(URL)
        case image(URL)
        case voiceNote(URL)
        case contact(CNContact)
        
        var url: URL? {
            switch self {
            case .file(let url):
                return url
            case .image(let url):
                return url
            case .voiceNote(let url):
                return url
            default:
                return nil
            }
        }
        var type: ChatAttachmentType {
            switch self {
            case .file(_):
                return .file
            case .image(_):
                return .image
            case .voiceNote(_):
                return .voiceNote
            case .contact(_):
                return .contact
            }
        }
        var mimeType: String {
            url?.mimeType ?? "application/octet-stream"
        }
        var fileName: String {
            if let url = url {
                return url.lastPathComponent
            } else if case .contact(let contact) = self {
                let name = [
                    contact.namePrefix,
                    contact.givenName,
                    contact.familyName,
                    contact.nameSuffix
                ].compactMap(\.nilIfEmpty).joined().nilIfEmpty ?? "contact"
                return "\(name).vcf"
            } else {
                return "attachment"
            }
        }
        var data: Data? {
            if let url = url {
                return try? Data.smartContents(of: url)
            } else if case .contact(let contact) = self {
                return try? CNContactVCardSerialization.data(with: [contact])
            } else {
                return nil
            }
        }
        var asChatAttachment: ChatAttachment? {
            guard let data = data,
                  let compressed = try? data.compressed(with: compression) else { return nil }
            print("Compressed size is \(compressed.count) bytes vs \(data.count) bytes uncompressed")
            return ChatAttachment(
                type: type,
                name: fileName,
                content: .data(compressed),
                compression: compression
            )
        }
    }
    
    var body: some View {
        ZStack {
            // Dummy view for presenting the contacts UI, see SwiftUIKit
            ContactPicker(showPicker: $attachmentContactPickerShown) {
                draftAttachments.append(.contact($0))
            }
            .frame(width: 0, height: 0, alignment: .center)
            
            VStack {
                if let id = replyingToMessageId, let message = messages[id] {
                    ClosableStatusBar(onClose: {
                        replyingToMessageId = nil
                    }) {
                        HStack {
                            Text("Replying to")
                            PlainMessageView(message: message)
                        }
                    }
                }
                let attachmentCount = draftAttachments.count
                if attachmentCount > 0 {
                    ClosableStatusBar(onClose: {
                        clearAttachments()
                    }) {
                        Text("\(attachmentCount) \("attachment".pluralized(with: attachmentCount))")
                    }
                }
                HStack {
                    Button(action: { attachmentActionSheetShown = true }) {
                        Image("ic_add_tmp")
                            .accentColor(BloomColors.primary_green)
                            .font(.system(size: iconSize))
                    }
                    TextField("Message \(channel.displayName(with: network))...", text: $draft, onCommit: sendDraft)
                        .font(Font.system(size: 16))
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(RoundedRectangle(cornerRadius: 19).fill(Color.white.opacity(0.17)))
                    if draft.isEmpty && draftAttachments.isEmpty {
                        VoiceNoteRecordButton {
                            draftAttachments.append(.voiceNote($0))
                        }
                        .font(.system(size: iconSize))
                    } else {
                        Button(action: sendDraft) {
                            Image("ic_send_green")
                        }
                    }
                }
            }
            .actionSheet(isPresented: $attachmentActionSheetShown) {
                ActionSheet(
                    title: Text("Add Attachment"),
                    message: Text("Large size content will take times to reach users. For now, we recommend to share only text, voice notes, contact, and low size images."),
                    buttons: [
                        .default(Text("Photo Library")) {
                            attachmentImagePickerStyle = .photoLibrary
                            attachmentImagePickerShown = true
                        },
                        .default(Text("Camera")) {
                            attachmentImagePickerStyle = .camera
                            attachmentImagePickerShown = true
                        },
                        .default(Text("Contact").foregroundColor(BloomColors.primary_green)) {
                            attachmentContactPickerShown = true
                        },
                        .default(Text("File")) {
                            attachmentFilePickerShown = true
                        },
                        .destructive(Text("Cancel")) {
                            // TODO: Workaround for attachmentFilePickerShown
                            // staying true if the user only slides the sheet
                            // down.
                            attachmentFilePickerShown = false
                        },
                    ]
                )
            }
            .fullScreenCover(isPresented: $attachmentImagePickerShown) {
                ImagePicker(sourceType: attachmentImagePickerStyle) {
                    if let url = $0 {
                        draftAttachments.append(.image(url))
                    }
                    attachmentImagePickerShown = false
                }.edgesIgnoringSafeArea(.all)
            }
            .fileImporter(isPresented: $attachmentFilePickerShown, allowedContentTypes: [.data], allowsMultipleSelection: false) {
                if case let .success(urls) = $0 {
                    draftAttachments += urls.map { .file($0) }
                }
                attachmentFilePickerShown = false
            }
        }
    }
    
    private func sendDraft() {
        if !draft.isEmpty || !draftAttachments.isEmpty {
            let attachments = draftAttachments.compactMap(\.asChatAttachment).nilIfEmpty
            controller.send(content: draft, on: channel, attaching: attachments, replyingTo: replyingToMessageId)
            clearDraft()
        }
    }
    
    private func clearDraft() {
        clearAttachments()
        draft = ""
        replyingToMessageId = nil
    }
    
    private func clearAttachments() {
        draftAttachments = []
    }
}

struct MessageComposeView_Previews: PreviewProvider {
    static let controller = ChatController(transport: MockTransport())
    @StateObject static var messages = Messages()
    @StateObject static var network = Network(messages: messages)
    @State static var replyingToMessageId: UUID? = nil
    static var previews: some View {
        MessageComposeView(channel: nil, controller: controller, replyingToMessageId: $replyingToMessageId)
            .environmentObject(messages)
            .environmentObject(network)
    }
}

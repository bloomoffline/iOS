//
//  PresenceView.swift
//  BloomApp
//
// 
//

import SwiftUI
import Bloom

struct PresenceView: View {
    let presence: ChatPresence
    let onCommit: (ChatChannel) -> Void
    
    @EnvironmentObject private var network: Network
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        HStack {
            Image(systemName: "circlebadge.fill")
                .foregroundColor(presence.status?.color ?? .gray)
            VStack(alignment: .leading) {
                Text(presence.user.displayName)
                    .multilineTextAlignment(.leading)
                if !presence.info.isEmpty {
                    Text(presence.info)
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .contextMenu {
            Button {
                navigation.open(channel: .dm([network.myId, presence.user.id]))
                onCommit(.dm([network.myId, presence.user.id]))
            } label: {
                Label("Send Private Message", image: "ic_private_message_tmp")
//                Text("Send Private Message")
//                Image("ic_private_message_tmp")
//                    .renderingMode(.template)
//                    .colorMultiply(Color.white)
            }
            
            Button {
                UIPasteboard.general.string = presence.user.id.uuidString
            } label: {
                Label("Copy User Bloom ID", image: "ic_copy_tmp")
//                Text("Send Private Message")
//                Image("ic_private_message_tmp")
//                    .renderingMode(.template)
//                    .colorMultiply(Color.white)
            }
//            Button(action: {
//                UIPasteboard.general.string = presence.user.name
//            }) {
//                Text("Copy User Name")
//                Image(systemName: "doc.on.doc")
//            }
//            if !presence.info.isEmpty {
//                Button(action: {
//                    UIPasteboard.general.string = presence.info
//                }) {
//                    Text("Copy Status Info")
//                    Image(systemName: "doc.on.doc")
//                }
//            }
            
        }
    }
}

struct PresenceView_Previews: PreviewProvider {
    @StateObject static var network = Network()
    @StateObject static var navigation = Navigation()
    
    static var previews: some View {
        PresenceView(presence: ChatPresence(user: .init())) { _ in }
            .environmentObject(network)
            .environmentObject(navigation)
    }
}

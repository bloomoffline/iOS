//
//  NewChannelView.swift
//  BloomApp
//
//  
//

import SwiftUI
import Bloom

// TODO: Support creation of DM channels

struct NewChannelView: View {
    let onCommit: (ChatChannel) -> Void
    
    @EnvironmentObject private var network: Network
    @EnvironmentObject private var navigation: Navigation
    @State private var channelNameDraft: String = ""
    
    var body: some View {
        VStack {
            Text("Start a Public Room...")
            HStack {
                Image("ic_announcement_tmp")
                AutoFocusTextField(placeholder: "Your Room Name", text: $channelNameDraft, onCommit: {
                    if !channelNameDraft.isEmpty {
                        // Enforce lower-kebab-case
                        let finalDraft = channelNameDraft
                            .lowercased()
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: " ", with: "-")
                        
                        onCommit(.room(finalDraft))
                    }
                })
                .accentColor(BloomColors.primary_green)
                .font(.title2)
                Button {
                    if !channelNameDraft.isEmpty {
                        // Enforce lower-kebab-case
                        let finalDraft = channelNameDraft
                            .lowercased()
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: " ", with: "-")
                        
                        onCommit(.room(finalDraft))
                    }
                } label: {
                    Image("ic_right_chevron_tmp")
                        .foregroundColor(.white)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            Text("…or send a Private Message")
                .font(.caption)
            List(network.allPresences) { presence in
                Button(action: {
                    onCommit(.dm([network.myId, presence.user.id]))
                }) {
                    PresenceView(presence: presence) { channel in
                        onCommit(channel)
                    }
                }
                .accentColor(Color.white)
                .frame(height: 50)
            }
            .listRowBackground(Color.white.opacity(0.17))
        }
        .padding(20)
    }
}

struct NewChannelView_Previews: PreviewProvider {
    @StateObject static var network = Network()
    @StateObject static var navigation = Navigation()
    
    static var previews: some View {
        NewChannelView { _ in }
            .environmentObject(network)
            .environmentObject(navigation)
    }
}

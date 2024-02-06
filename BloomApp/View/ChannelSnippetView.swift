//
//  ChannelSnippetView.swift
//  BloomApp
//
//  
//

import SwiftUI
import Bloom

struct ChannelSnippetView: View {
    let channel: ChatChannel?
    
    @EnvironmentObject private var messages: Messages
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var network: Network
    
    var body: some View {
        HStack {
            if messages.unreadChannels.contains(channel) {
                Image(systemName: "circlebadge.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 10)
            } else {
                Image("")
                    .resizable()
                    .frame(width: 10, height: 10)
            }
            if case .dm(_) = channel {
                Image("ic_profile_2_tmp")
                    .resizable()
                    .frame(width: 25, height: 25)
            } else {
                Image("ic_announcement_tmp")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            VStack(alignment: .leading) {
                if case .dm(_) = channel {
                    Text(channel.rawDisplayName(with: network))
                        .font(.headline)
                } else {
                    Text("#\(channel.rawDisplayName(with: network))")
                        .font(.headline)
                }
                if let message = messages[channel].last,
                   settings.presentation.showChannelPreviews {
                    PlainMessageView(message: message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if messages.pinnedChannels.contains(channel) {
                Image("ic_pin_tmp")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
        }
    }
}

struct ChannelSnippetView_Previews: PreviewProvider {
    @StateObject static var messages = Messages()
    @StateObject static var settings = Settings()
    @StateObject static var network = Network(messages: messages)
    static var previews: some View {
        ChannelSnippetView(channel: .room("test"))
            .environmentObject(messages)
            .environmentObject(settings)
            .environmentObject(network)
    }
}

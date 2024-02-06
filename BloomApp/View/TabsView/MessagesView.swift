//
//  MessagesView.swift
//  BloomApp
//
// 
//

import Bloom
import SwiftUI

struct MessagesView: View {
    let channels: [ChatChannel?]
    let controller: ChatController
    
    @EnvironmentObject private var messages: Messages
    @EnvironmentObject private var navigation: Navigation
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var network: Network
    @State private var newChannels: [ChatChannel] = []
    @State private var channelDraftSheetShown: Bool = false
    @State private var deletingChannels: [ChatChannel?] = []
    @State private var deletionConfirmationShown: Bool = false
    
    private var allChannels: [ChatChannel?] {
        channels + newChannels.filter { !channels.contains($0) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Messages")
                        .bold()
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal)
                
                Button(action: {
                    channelDraftSheetShown = true
                }) {
                    Image("ic_add_tmp")
                    Text("Start a Public Room or Private Message")
                }
                .foregroundColor(.primary)
                .padding()
                .frame(height: 56)
                .background(Color.white.opacity(0.17))
                .clipShape(.rect(cornerRadius: 17))
                
                List {
                    ForEach(allChannels, id: \.self) { channel in
                        ZStack {
                            ChannelSnippetView(channel: channel)
                            NavigationLink(destination: ChannelView(channel: channel, controller: controller), tag: channel, selection: $navigation.activeChannel) {
                                EmptyView()
                            }.opacity(0)
                        }
                        .frame(height: 50)
                        .contextMenu {
                            if !messages.pinnedChannels.contains(channel) {
                                Button {
                                    messages.pin(channel: channel)
                                } label: {
                                    Label("Pin", image: "ic_pin_tmp")
                                }
                            } else if channel != nil {
                                Button {
                                    messages.unpin(channel: channel)
                                } label: {
                                    Label("Unpin", image: "pin.slash.fill")
                                }
                            }
                            Button {
                                deletingChannels = [channel]
                                deletionConfirmationShown = true
                            } label: {
                                Label("Delete locally", image: "ic_delete_tmp")
                            }
//                            if messages.unreadChannels.contains(channel) {
//                                Button(action: {
//                                    messages.markAsRead(channel: channel)
//                                }) {
//                                    Text("Mark as Read")
//                                    Image(systemName: "circlebadge")
//                                }
//                            }
                            
//                            if let channel = channel {
//                                Button(action: {
//                                    UIPasteboard.general.string = channel.displayName(with: network)
//                                }) {
//                                    Text("Copy Channel Name")
//                                    Image(systemName: "doc.on.doc")
//                                }
//                            }
                            if case .dm(let bloomId) = channel {
                                Button {
                                    UIPasteboard.general.string = bloomId.first?.uuidString ?? ""
                                } label: {
                                    Label("Copy User Bloom ID",
                                          image: "ic_copy_tmp")
                                }
                            } else {
                                Button {
                                    UIPasteboard.general.url = URL(string: "bloomoffline:///channel\(channel.map { "/\($0)" } ?? "")")
                                } label: {
                                    Label("Copy Room Bloom URL",
                                          image: "ic_copy_tmp")
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        deletingChannels = indexSet.map { allChannels[$0] }
                        deletionConfirmationShown = true
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .sheet(isPresented: $channelDraftSheetShown) {
                NewChannelView {
                    channelDraftSheetShown = false
                    newChannels = [$0]
                    navigation.open(channel: $0)
                }
            }
            .actionSheet(isPresented: $deletionConfirmationShown) {
                ActionSheet(
                    title: Text("Are you sure you want to delete ALL messages in \(deletingChannels.map { $0.displayName(with: network) }.joined(separator: ", "))?"),
                    message: Text("Messages will only be deleted locally."),
                    buttons: [
                        .destructive(Text("Delete")) {
                            for channel in deletingChannels {
                                messages.clear(channel: channel)
                            }
                            newChannels.removeAll(where: deletingChannels.contains)
                            deletingChannels = []
                        },
                        .cancel {
                            deletingChannels = []
                        }
                    ]
                )
            }
            .onReceive(navigation.$activeChannel) {
                if case let channel?? = $0, !allChannels.contains(channel) {
                    newChannels = [channel]
                }
            }
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    @StateObject static var messages = Messages()
    @StateObject static var navigation = Navigation()
    @StateObject static var settings = Settings()
    @StateObject static var network = Network(messages: messages)
    static var previews: some View {
        MessagesView(channels: [], controller: ChatController(transport: MockTransport()))
            .environmentObject(messages)
            .environmentObject(navigation)
            .environmentObject(settings)
            .environmentObject(network)
    }
}

//
//  NetworkView.swift
//  BloomApp
//
//  
//

import Bloom
import SwiftUI

struct NetworkView: View {
    let controller: ChatController

    @EnvironmentObject private var network: Network
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    let nearbyCount = network.nearbyUsers.count
                    let reachableCount = network.presences.filter { $0.key != controller.me.id }.count
                    HStack {
                        Image("ic_bloom_tmp")
                            .frame(width: 35, height: 35)
                        Text("\(reachableCount) \("user".pluralized(with: reachableCount)) reachable, \(nearbyCount) \("user".pluralized(with: nearbyCount)) nearby")
                            
                    }
                    .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                    .frame(height: 56)
                } header: {
                    Text("Network")
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets())
                .listRowBackground(BloomColors.primary_green)

                Section {
                    List(network.allPresences) { presence in
                        PresenceView(presence: presence, onCommit: { _ in })
                            .frame(height: 70)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                } header: {
                    Text("Connected Users")
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.white.opacity(0.17))
//                Section(header: Text("NEARBY USERS")) {
//                    List(network.nearbyUsers) { user in
//                        HStack {
//                            Text(user.displayName)
//                            Spacer()
//                            if let rssi = user.rssi {
//                                Image(systemName: "antenna.radiowaves.left.and.right")
//                                Text("\(rssi) dB")
//                            }
//                        }
//                        .contextMenu {
//                            if let chatUser = user.chatUser {
//                                Button(action: {
//                                    UIPasteboard.general.string = chatUser.id.uuidString
//                                }) {
//                                    Text("Copy User ID")
//                                    Image(systemName: "doc.on.doc")
//                                }
//                                Button(action: {
//                                    UIPasteboard.general.string = chatUser.name
//                                }) {
//                                    Text("Copy User Name")
//                                    Image(systemName: "doc.on.doc")
//                                }
//                                Button(action: {
//                                    navigation.open(channel: .dm([network.myId, chatUser.id]))
//                                }) {
//                                    Text("Open DM channel")
//                                    Image(systemName: "at")
//                                }
//                            }
//                            Button(action: {
//                                UIPasteboard.general.string = user.peripheralIdentifier.uuidString
//                            }) {
//                                Text("Copy Peripheral ID")
//                                Image(systemName: "doc.on.doc")
//                            }
//                            if let peripheralName = user.peripheralName {
//                                Button(action: {
//                                    UIPasteboard.general.string = peripheralName
//                                }) {
//                                    Text("Copy Peripheral Name")
//                                    Image(systemName: "doc.on.doc")
//                                }
//                            }
//                            if let rssi = user.rssi {
//                                Button(action: {
//                                    UIPasteboard.general.string = String(rssi)
//                                }) {
//                                    Text("Copy RSSI")
//                                    Image(systemName: "doc.on.doc")
//                                }
//                            }
//                        }
//                    }
//                }
                
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NetworkView_Previews: PreviewProvider {
    static let alice = ChatUser(name: "Alice")
    static let bob = ChatUser(name: "Bob")
    @StateObject static var network = Network(nearbyUsers: [
        NearbyUser(peripheralIdentifier: UUID(uuidString: "6b61a69b-f4b4-4321-92db-9d61653ddaf6")!, chatUser: alice, rssi: -49),
        NearbyUser(peripheralIdentifier: UUID(uuidString: "b7b7d248-9640-490d-8187-44fc9ebfa1ff")!, chatUser: bob, rssi: -55),
    ], presences: [
        ChatPresence(user: alice, status: .online),
        ChatPresence(user: bob, status: .busy, info: "At the gym"),
    ], messages: Messages())
    @StateObject static var navigation = Navigation()
    
    static var previews: some View {
        NetworkView(controller: ChatController(transport: MockTransport()))
            .environmentObject(network)
            .environmentObject(navigation)
    }
}

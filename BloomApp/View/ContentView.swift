//
//  ContentView.swift
//  BloomApp
//
//  
//

import Bloom
import SwiftUI

struct ContentView: View {
    let controller: ChatController
    
    @EnvironmentObject private var messages: Messages
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        TabView(selection: $navigation.selectionTab) {
            NetworkView(controller: controller)
                .tabItem {
                    VStack {
                        Image("ic_network_basic_tmp")
                        Text("Network")
                    }
                }
                .tag(1)
            MessagesView(channels: messages.channels, controller: controller)
                .tabItem {
                    VStack {
                        Image("ic_messages_basic_tmp")
                        Text("Messages")
                    }
                }
                .tag(2)
            ProfileView()
                .tabItem {
                    VStack {
                        Image("ic_profile_tmp")
                        Text("Profile")
                    }
                }
                .tag(3)
        }
        .accentColor(BloomColors.primary_green)
        .environmentObject(messages)
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var settings = Settings()
    @StateObject static var messages = Messages()
    @StateObject static var navigation = Navigation()
    @StateObject static var profile = Profile()
    @StateObject static var network = Network(myId: profile.me.id, messages: messages)
    static var previews: some View {
        ContentView(controller: ChatController(transport: MockTransport()))
            .environmentObject(settings)
            .environmentObject(messages)
            .environmentObject(navigation)
            .environmentObject(network)
            .environmentObject(profile)
    }
}

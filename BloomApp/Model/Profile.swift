//
//  Profile.swift
//  BloomApp
//
//  
//

import Combine
import Bloom

class Profile: ObservableObject {
    @Published(persistingTo: "Profile/presence.json") var presence: ChatPresence = ChatPresence()
    
    var me: ChatUser { presence.user }
}

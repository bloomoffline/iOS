//
//  Navigation.swift
//  BloomApp
//
//  
//

import Combine
import Bloom

class Navigation: ObservableObject {
    @Published var activeChannel: ChatChannel?? = nil
    @Published var selectionTab = 1
    func open(channel: ChatChannel?) {
        activeChannel = Optional.some(channel)
        self.selectionTab = 2
    }
}

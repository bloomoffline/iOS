//
//  Settings.swift
//  BloomApp
//
//  
//

import Combine
import Foundation

class Settings: ObservableObject {
    @Published(persistingTo: "Settings/presentation.json") var presentation = Presentation()
    @Published(persistingTo: "Settings/bluetooth.json") var bluetooth = Bluetooth()
    @Published(persistingTo: "Settings/notification.json") var notification = Notification()
    
    struct Presentation: Codable {
        var messageHistoryStyle: MessageHistoryStyle = .bubbles
        var showChannelPreviews: Bool = true
    }
    
    struct Bluetooth: Codable {
        var advertisingEnabled: Bool = true
        var scanningEnabled: Bool = true
        var monitorSignalStrength: Bool = true
        var monitorSignalStrengthInterval: Int = 5 // seconds
    }
    
    struct Notification: Codable {
        var enable: Bool = true
    }
}

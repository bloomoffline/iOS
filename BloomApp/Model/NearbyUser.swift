//
//  NearbyUser.swift
//  BloomApp
//
// 
//

import Bloom
import Foundation

struct NearbyUser: Identifiable, Hashable {
    var peripheralIdentifier: UUID
    var peripheralName: String? = nil
    var chatUser: ChatUser? = nil
    var rssi: Int? = nil // in dB
    
    var id: UUID { peripheralIdentifier }
    var displayName: String { chatUser?.displayName ?? peripheralName ?? peripheralIdentifier.uuidString }
}

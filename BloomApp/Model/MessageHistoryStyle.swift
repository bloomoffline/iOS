//
//  MessageHistoryStyle.swift
//  BloomApp
//
//  
//

enum MessageHistoryStyle: String, CaseIterable, Hashable, CustomStringConvertible, Codable {
    case compact = "Compact"
    case bubbles = "Bubbles"
    
    var description: String { rawValue }
}

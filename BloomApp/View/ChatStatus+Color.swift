//
//  ChatStatus+Color.swift
//  BloomApp
//
//  
//

import Bloom
import SwiftUI

extension ChatStatus {
    var color: Color {
        switch self {
        case .online:
            return BloomColors.dot_green
        case .busy:
            return BloomColors.dot_yellow
        case .emergency:
            return BloomColors.dot_red
//        case .offline:
//            return .gray
        }
    }
}

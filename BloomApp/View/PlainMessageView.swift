//
//  PlainMessageView.swift
//  BloomApp
//
// 
//

import Bloom
import SwiftUI

struct PlainMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        Text("\(message.author.displayName): \(message.displayContent)")
    }
}

struct PlainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        PlainMessageView(message: ChatMessage(author: ChatUser(name: "Alice"), content: "Test"))
    }
}

//
//  ChatMessageModel.swift
//  BeerAI Watch App
//
//  Created by Tomescu Vlad on 21.06.2023.
//

import Foundation
struct ChatMessage {
    let id: String
    let content: String
    let createdAt: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case chatGPT
}

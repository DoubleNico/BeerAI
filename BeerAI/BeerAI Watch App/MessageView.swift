//
//  MessageView.swift
//  BeerAI Watch App
//
//  Created by Tomescu Vlad on 21.06.2023.
//

import Foundation
import SwiftUI

struct MessageView: View {
    var message: ChatMessage
    var body: some View {
            HStack{
                    if message.sender == .me{Spacer()}
                    Text(message.content)
                        .foregroundColor(message.sender == .me ? .white : nil)
                        .padding()
                        .background(message.sender == .me ? .blue : .gray.opacity(0.4))
                        .cornerRadius(24)
                    if message.sender == .chatGPT{Spacer()}
            }
        }
           
}

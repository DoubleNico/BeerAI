//
//  AICompletionsModel.swift
//  BeerAI Watch App
//
//  Created by Tomescu Vlad on 21.06.2023.
//

import Foundation
struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}
struct OpenAIResponse: Codable {
    let id: String
    let choices: [ResponseChoice]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case choices = "choices"
    }
}


struct ResponseChoice: Codable {
    let text: String
}


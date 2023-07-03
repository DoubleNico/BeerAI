//
//  AIService.swift
//  BeerAI Watch App
//
//  Created by Tomescu Vlad on 21.06.2023.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/completions"
    var isLoading: Bool = false
    
    func sendMessage(message: String) -> AnyPublisher<OpenAIResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.6, max_tokens: 256)
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Constants.OpenAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else {return}
            AF.request(self.baseUrl, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(OpenAIResponse.self, from: data)
                        promise(.success(result))
                    } catch let error {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//
//  ContentView.swift
//  BeerAI Watch App
//
//  Created by Tomescu Vlad on 21.06.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var chatMessages: [ChatMessage] = []
    @State var message: String = ""
    let openAIService = OpenAIService()
    var isLoading: Bool = OpenAIService().isLoading
    
    @State var lastMessageID: String = ""
    
    ///- Dark mode/Light mode variable
    @Environment(\.colorScheme) var colorScheme
    
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { message in
                            MessageView(message: message)
                        }
                    }
                }
                .onChange(of: self.lastMessageID) { id in
                    withAnimation{
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Enter a message", text: $message) {}
                    .padding()
                    .background(colorScheme == .dark ? .gray.opacity(0.2) : .gray.opacity(0.4))
                    .cornerRadius(12)
                    .buttonStyle(PlainButtonStyle())
                Button{
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.blue)
                        .padding(.horizontal, 5)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
    }
        
    func sendMessage (){
        guard message != "" else {return}
        
        let myMessage = ChatMessage(id: UUID().uuidString, content: message, createdAt: Date(), sender: .me)
        chatMessages.append(myMessage)
        lastMessageID = myMessage.id
        
        openAIService.sendMessage(message: message)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { response in
                guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
                let chatGPTMessage = ChatMessage(id: response.id, content: textResponse, createdAt: Date(), sender: .chatGPT)
                
                chatMessages.append(chatGPTMessage)
                lastMessageID = chatGPTMessage.id
                print("1")
            }
            .store(in: &cancellables)            
        message = ""
    }
}

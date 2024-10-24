//
//  ChatbotConversationScreen.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/24/24.
//
import SwiftUI

// MARK: - Message Model
public struct ChatMessage: Identifiable {
    public let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

// MARK: - Main Chat View
public struct ChatbotConversationScreen: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(content: "Hello! I'm your GlucoGuide assistant. How can I help you manage your diabetes today?", isUser: false, timestamp: Date())
    ]
    @State private var newMessage = ""
    @State private var isListening = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    public init() {}
    
    public var body: some View {
        ZStack {
            secondcolor.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                chatHeader
                
                // Chat Messages
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Input Area
                chatInputArea
            }
        }
    }
    
    // MARK: - Chat Header
    private var chatHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(maincolor)
                        .imageScale(.large)
                }
                
                Spacer()
                
                Text("GlucoGuide Assistant")
                    .font(.headline)
                    .foregroundColor(textcolor)
                
                Spacer()
                
                Button(action: {
                    // Handle info action
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(maincolor)
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Divider()
                .background(bordercolor)
        }
        .background(thirdcolor)
    }
    
    // MARK: - Chat Input Area
    private var chatInputArea: some View {
        VStack(spacing: 0) {
            Divider()
                .background(bordercolor)
            
            HStack(spacing: 12) {
                // Text Input
                HStack {
                    TextField("Type your message...", text: $newMessage)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(secondcolor.opacity(0.2))
                        .cornerRadius(20)
                    
                    // Voice Input Button
                    Button(action: { isListening.toggle() }) {
                        Image(systemName: isListening ? "waveform" : "mic")
                            .foregroundColor(isListening ? .red : maincolor)
                            .padding(8)
                            .background(secondcolor.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                // Send Button
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(!newMessage.isEmpty ? maincolor : maincolor.opacity(0.5))
                }
            }
            .padding()
            .background(thirdcolor)
        }
    }
    
    // MARK: - Actions
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Add user message
        let userMessage = ChatMessage(content: newMessage, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        // Simulate AI response (replace with actual AI integration)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ChatMessage(
                content: "I understand you're asking about \(newMessage). Let me help you with that...",
                isUser: false,
                timestamp: Date()
            )
            messages.append(response)
        }
        
        newMessage = ""
    }
}

// MARK: - Chat Bubble View
private struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(message.isUser ? maincolor : secondcolor.opacity(0.3))
                    .foregroundColor(message.isUser ? .white : textcolor)
                    .cornerRadius(20)
                
                Text(formatTimestamp(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isUser { Spacer() }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Preview Provider
struct ChatbotConversationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotConversationScreen()
    }
}

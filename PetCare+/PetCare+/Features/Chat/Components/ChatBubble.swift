//
//  ChatBubble.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 8) {
                if message.isUser {
                    Spacer()
                }

                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                    Text(message.content)
                        .padding(12)
                        .background(message.isUser ? AppColors.accent : Color(.systemGray6))
                        .foregroundStyle(message.isUser ? .white : AppColors.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Text(message.timeString)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: geometry.size.width * 0.7, alignment: message.isUser ? .trailing : .leading)

                if !message.isUser {
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .frame(minHeight: 44)
    }
}

// MARK: - QuickPromptButton Component

struct QuickPromptButton: View {
    let prompt: QuickPrompt
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: prompt.icon)
                    .font(.caption)
                Text(prompt.rawValue)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppColors.secondaryBackground)
            .foregroundStyle(AppColors.textPrimary)
            .clipShape(Capsule())
        }
    }
}

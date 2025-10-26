//
//  ChatMessage.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation

// MARK: - Chat Message

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date

    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

// MARK: - Quick Prompt

enum QuickPrompt: String, CaseIterable {
    case behavior = "Davranış Analizi"
    case health = "Sağlık Önerileri"
    case nutrition = "Beslenme Tavsiyeleri"
    case training = "Eğitim İpuçları"
    case exercise = "Egzersiz Programı"
    case grooming = "Bakım Önerileri"

    var icon: String {
        switch self {
        case .behavior: return "brain.head.profile"
        case .health: return "cross.case.fill"
        case .nutrition: return "fork.knife"
        case .training: return "figure.walk"
        case .exercise: return "figure.run"
        case .grooming: return "scissors"
        }
    }

    var prompt: String {
        switch self {
        case .behavior:
            return "Son günlerde farklı davranışlar sergiledi. Bu davranışları analiz edebilir misin?"
        case .health:
            return "Genel sağlık durumu için önerilerin neler?"
        case .nutrition:
            return "İdeal beslenme planı nasıl olmalı?"
        case .training:
            return "Temel eğitim için nereden başlamalıyım?"
        case .exercise:
            return "Yaşına ve türüne uygun egzersiz programı önerir misin?"
        case .grooming:
            return "Bakım rutini nasıl olmalı?"
        }
    }
}

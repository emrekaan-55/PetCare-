//
//  ChatViewModel.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var messages: [ChatMessage] = []
    @Published var currentMessage: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedPet: Pet?

    // MARK: - Properties

    private let geminiService = GeminiService.shared

    // MARK: - Initialization

    init() {
        // Welcome message
        addSystemMessage("Merhaba! Ben evcil hayvan asistanınızım. Size nasıl yardımcı olabilirim?")
    }

    // MARK: - Methods

    /// Mesaj gönder
    func sendMessage() {
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let pet = selectedPet else {
            errorMessage = "Lütfen bir evcil hayvan seçin"
            return
        }

        let userMessage = currentMessage
        currentMessage = ""

        // Kullanıcı mesajını ekle
        addUserMessage(userMessage)

        // AI yanıtı al
        Task {
            await getAIResponse(for: userMessage, pet: pet)
        }
    }

    /// Quick prompt gönder
    func sendQuickPrompt(_ prompt: QuickPrompt) {
        guard let pet = selectedPet else {
            errorMessage = "Lütfen bir evcil hayvan seçin"
            return
        }

        let message = prompt.prompt
        addUserMessage(message)

        Task {
            await getAIResponse(for: message, pet: pet)
        }
    }

    /// Konuşmayı temizle
    func clearChat() {
        messages.removeAll()
        addSystemMessage("Konuşma temizlendi. Yeni bir sohbet başlayabilirsiniz.")
    }

    /// Pet seçildiğinde
    func onPetSelected(_ pet: Pet) {
        selectedPet = pet
        if messages.isEmpty || messages.count == 1 {
            addSystemMessage("Merhaba! \(pet.name) hakkında size nasıl yardımcı olabilirim?")
        }
    }

    // MARK: - Private Methods

    private func addUserMessage(_ content: String) {
        let message = ChatMessage(content: content, isUser: true)
        messages.append(message)
    }

    private func addAIMessage(_ content: String) {
        let message = ChatMessage(content: content, isUser: false)
        messages.append(message)
    }

    private func addSystemMessage(_ content: String) {
        let message = ChatMessage(content: content, isUser: false)
        messages.append(message)
    }

    private func getAIResponse(for question: String, pet: Pet) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await geminiService.askAboutPet(
                petName: pet.name,
                species: pet.species.rawValue,
                question: question
            )

            addAIMessage(response)
        } catch {
            errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
            addSystemMessage("Üzgünüm, bir hata oluştu. Lütfen tekrar deneyin.")
        }

        isLoading = false
    }
}

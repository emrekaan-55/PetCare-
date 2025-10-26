//
//  PetChatView.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI
import SwiftData

struct PetChatView: View {
    @Query private var pets: [Pet]
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedPet: Pet?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if selectedPet != nil {
                    // Messages
                    messagesSection

                    // Quick Prompts (show when no messages)
                    if viewModel.messages.count <= 1 {
                        quickPromptsSection
                    }

                    Divider()

                    // Input Section
                    inputSection
                } else {
                    // Pet Selection
                    petSelectionView
                }
            }
            .navigationTitle("AI Asistan")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedPet != nil {
                        Menu {
                            Button {
                                viewModel.clearChat()
                            } label: {
                                Label("Sohbeti Temizle", systemImage: "trash")
                            }

                            Button {
                                selectedPet = nil
                            } label: {
                                Label("Pet Değiştir", systemImage: "pawprint")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .onAppear {
            if selectedPet == nil, let firstPet = pets.first {
                selectedPet = firstPet
                viewModel.onPetSelected(firstPet)
            }
        }
        .onChange(of: selectedPet) { oldValue, newValue in
            if let pet = newValue {
                viewModel.onPetSelected(pet)
            }
        }
    }

    // MARK: - Messages Section

    private var messagesSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        ChatBubble(message: message)
                            .id(message.id)
                    }

                    if viewModel.isLoading {
                        HStack(spacing: 8) {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Düşünüyor...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                }
                .padding(.vertical)
            }
            .onChange(of: viewModel.messages.count) { oldValue, newValue in
                if let lastMessage = viewModel.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - Quick Prompts Section

    private var quickPromptsSection: some View {
        VStack(spacing: 12) {
            Text("Hızlı Sorular")
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(QuickPrompt.allCases, id: \.self) { prompt in
                        QuickPromptButton(prompt: prompt) {
                            viewModel.sendQuickPrompt(prompt)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Input Section

    private var inputSection: some View {
        HStack(spacing: 12) {
            TextField("Mesajınızı yazın...", text: $viewModel.currentMessage, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...5)
                .disabled(viewModel.isLoading)

            Button {
                viewModel.sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        viewModel.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading
                            ? .gray
                            : AppColors.accent
                    )
            }
            .disabled(viewModel.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: - Pet Selection View

    private var petSelectionView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.accent.opacity(0.5))

            Text("Evcil Hayvan Seçin")
                .font(.title2)
                .fontWeight(.semibold)

            Text("AI asistan ile sohbet etmek için bir evcil hayvan seçin")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if !pets.isEmpty {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(pets) { pet in
                            Button {
                                selectedPet = pet
                            } label: {
                                HStack {
                                    Text(pet.species.icon)
                                        .font(.title)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pet.name)
                                            .font(.headline)
                                            .foregroundStyle(.primary)

                                        Text("\(pet.species.rawValue) • \(pet.ageString)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .background(AppColors.secondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                }
            }

            Spacer()
        }
    }
}

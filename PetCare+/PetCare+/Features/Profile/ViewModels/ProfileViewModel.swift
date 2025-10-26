//
//  ProfileViewModel.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var pets: [Pet] = []
    @Published var isLoading = false
    @Published var showingAddPet = false
    @Published var selectedPet: Pet?

    // Settings
    @Published var notificationsEnabled = true
    @Published var selectedTheme: AppTheme = .system
    @Published var dailyReminderTime = Date()

    // MARK: - Properties

    private let context: ModelContext

    // MARK: - App Theme

    enum AppTheme: String, CaseIterable {
        case light = "Açık"
        case dark = "Koyu"
        case system = "Sistem"

        var icon: String {
            switch self {
            case .light: return "sun.max.fill"
            case .dark: return "moon.fill"
            case .system: return "circle.lefthalf.filled"
            }
        }
    }

    // MARK: - Initialization

    init(context: ModelContext) {
        self.context = context
        loadSettings()
    }

    // MARK: - Methods

    /// Pet'leri yükle
    func loadPets() {
        isLoading = true
        do {
            let descriptor = FetchDescriptor<Pet>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
            pets = try context.fetch(descriptor)
        } catch {
            print("Error loading pets: \(error)")
        }
        isLoading = false
    }

    /// Pet ekle
    func addPet(
        name: String,
        species: PetSpecies,
        breed: String,
        gender: PetGender,
        birthDate: Date,
        weight: Double,
        notes: String
    ) {
        let pet = Pet(
            name: name,
            species: species,
            breed: breed,
            gender: gender,
            birthDate: birthDate,
            weight: weight,
            notes: notes
        )

        context.insert(pet)
        saveContext()
        loadPets()
    }

    /// Pet güncelle
    func updatePet(
        _ pet: Pet,
        name: String,
        species: PetSpecies,
        breed: String,
        gender: PetGender,
        birthDate: Date,
        weight: Double,
        notes: String
    ) {
        pet.name = name
        pet.species = species
        pet.breed = breed
        pet.gender = gender
        pet.birthDate = birthDate
        pet.weight = weight
        pet.notes = notes
        pet.updatedAt = Date()

        saveContext()
        loadPets()
    }

    /// Pet sil
    func deletePet(_ pet: Pet) {
        context.delete(pet)
        saveContext()
        loadPets()
    }

    /// Pet aktif/pasif durumunu değiştir
    func togglePetActiveStatus(_ pet: Pet) {
        pet.isActive.toggle()
        pet.updatedAt = Date()
        saveContext()
        loadPets()
    }

    // MARK: - Settings Methods

    /// Ayarları yükle
    private func loadSettings() {
        // UserDefaults'tan ayarları yükle
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")

        if let themeRaw = UserDefaults.standard.string(forKey: "appTheme"),
           let theme = AppTheme(rawValue: themeRaw) {
            selectedTheme = theme
        }

        if let reminderTime = UserDefaults.standard.object(forKey: "dailyReminderTime") as? Date {
            dailyReminderTime = reminderTime
        }
    }

    /// Ayarları kaydet
    func saveSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "appTheme")
        UserDefaults.standard.set(dailyReminderTime, forKey: "dailyReminderTime")
    }

    /// Bildirimleri aç/kapat
    func toggleNotifications() {
        notificationsEnabled.toggle()
        saveSettings()
    }

    /// Tema değiştir
    func changeTheme(_ theme: AppTheme) {
        selectedTheme = theme
        saveSettings()
    }

    /// Günlük hatırlatma saatini güncelle
    func updateDailyReminder(_ time: Date) {
        dailyReminderTime = time
        saveSettings()
    }

    // MARK: - Private Methods

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

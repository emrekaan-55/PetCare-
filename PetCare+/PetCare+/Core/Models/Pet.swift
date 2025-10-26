//
//  Pet.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import Foundation
import SwiftData

// MARK: - Pet Species

enum PetSpecies: String, Codable, CaseIterable {
    case dog = "Köpek"
    case cat = "Kedi"
    case bird = "Kuş"
    case rabbit = "Tavşan"
    case hamster = "Hamster"
    case fish = "Balık"
    case reptile = "Sürüngen"
    case other = "Diğer"

    var icon: String {
        switch self {
        case .dog: return "🐕"
        case .cat: return "🐈"
        case .bird: return "🦜"
        case .rabbit: return "🐰"
        case .hamster: return "🐹"
        case .fish: return "🐠"
        case .reptile: return "🦎"
        case .other: return "🐾"
        }
    }

    var sfSymbol: String {
        switch self {
        case .dog: return "pawprint.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .rabbit: return "hare.fill"
        case .hamster: return "tortoise.fill"
        case .fish: return "fish.fill"
        case .reptile: return "lizard.fill"
        case .other: return "pawprint"
        }
    }
}

// MARK: - Pet Gender

enum PetGender: String, Codable {
    case male = "Erkek"
    case female = "Dişi"
    case unknown = "Bilinmiyor"

    var icon: String {
        switch self {
        case .male: return "♂️"
        case .female: return "♀️"
        case .unknown: return "❓"
        }
    }
}

// MARK: - Pet Model

@Model
final class Pet {
    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var name: String
    var species: PetSpecies
    var breed: String
    var gender: PetGender
    var birthDate: Date
    var weight: Double // kg cinsinden
    var profileImageData: Data? // Profil fotoğrafı
    var notes: String
    var isActive: Bool // Aktif pet mi (örn: vefat eden petler için false)
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Relationships

    @Relationship(deleteRule: .cascade)
    var routines: [DailyRoutine]

    @Relationship(deleteRule: .cascade)
    var healthRecords: [HealthRecord]

    @Relationship(deleteRule: .cascade)
    var exercises: [Exercise]

    @Relationship(deleteRule: .cascade)
    var appointments: [Appointment]

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        species: PetSpecies,
        breed: String,
        gender: PetGender = .unknown,
        birthDate: Date,
        weight: Double,
        profileImageData: Data? = nil,
        notes: String = "",
        isActive: Bool = true,
        routines: [DailyRoutine] = [],
        healthRecords: [HealthRecord] = [],
        exercises: [Exercise] = [],
        appointments: [Appointment] = []
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.breed = breed
        self.gender = gender
        self.birthDate = birthDate
        self.weight = weight
        self.profileImageData = profileImageData
        self.notes = notes
        self.isActive = isActive
        self.createdAt = Date()
        self.updatedAt = Date()
        self.routines = routines
        self.healthRecords = healthRecords
        self.exercises = exercises
        self.appointments = appointments
    }
}

// MARK: - Computed Properties

extension Pet {
    /// Pet'in yaşını hesaplar (yıl cinsinden)
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }

    /// Pet'in yaşını string formatında döner (örn: "2 yıl 3 ay")
    var ageString: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0

        if years > 0 && months > 0 {
            return "\(years) yıl \(months) ay"
        } else if years > 0 {
            return "\(years) yıl"
        } else {
            return "\(months) ay"
        }
    }

    /// Bugünkü tamamlanmış routine sayısı
    var todayCompletedRoutinesCount: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return routines.filter { routine in
            calendar.isDate(routine.completedAt ?? Date.distantPast, inSameDayAs: today) &&
            routine.isCompleted
        }.count
    }

    /// Bugünkü toplam routine sayısı
    var todayTotalRoutinesCount: Int {
        return routines.filter { $0.isActive }.count
    }

    /// Bugünkü rutin tamamlanma yüzdesi
    var todayRoutineProgress: Double {
        guard todayTotalRoutinesCount > 0 else { return 0 }
        return Double(todayCompletedRoutinesCount) / Double(todayTotalRoutinesCount)
    }
}

// MARK: - Sample Data

extension Pet {
    /// Mock data için örnek pet
    static var sample: Pet {
        Pet(
            name: "Karamel",
            species: .cat,
            breed: "British Shorthair",
            gender: .female,
            birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
            weight: 4.5,
            notes: "Çok tatlı ve oyuncu bir kedi"
        )
    }

    /// Mock data için örnek petler
    static var samples: [Pet] {
        [
            Pet(
                name: "Karamel",
                species: .cat,
                breed: "British Shorthair",
                gender: .female,
                birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
                weight: 4.5,
                notes: "Çok tatlı ve oyuncu bir kedi"
            ),
            Pet(
                name: "Max",
                species: .dog,
                breed: "Golden Retriever",
                gender: .male,
                birthDate: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
                weight: 30.0,
                notes: "Enerjik ve sadık bir köpek"
            ),
            Pet(
                name: "Luna",
                species: .cat,
                breed: "Scottish Fold",
                gender: .female,
                birthDate: Calendar.current.date(byAdding: .month, value: -8, to: Date())!,
                weight: 3.2,
                notes: "Uysal ve sakin"
            )
        ]
    }
}

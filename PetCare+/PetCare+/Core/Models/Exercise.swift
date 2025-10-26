//
//  Exercise.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Exercise Type

enum ExerciseType: String, Codable, CaseIterable {
    case walk = "Yürüyüş"
    case run = "Koşu"
    case play = "Oyun"
    case training = "Eğitim"
    case swimming = "Yüzme"
    case fetch = "Top Oyunu"
    case other = "Diğer"

    var icon: String {
        switch self {
        case .walk: return "figure.walk"
        case .run: return "figure.run"
        case .play: return "figure.play"
        case .training: return "figure.training"
        case .swimming: return "figure.pool.swim"
        case .fetch: return "tennisball.fill"
        case .other: return "figure.flexibility"
        }
    }

    var color: String {
        switch self {
        case .walk: return "green"
        case .run: return "orange"
        case .play: return "purple"
        case .training: return "blue"
        case .swimming: return "cyan"
        case .fetch: return "yellow"
        case .other: return "gray"
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .walk: return .green
        case .run: return .orange
        case .play: return .purple
        case .training: return .blue
        case .swimming: return .cyan
        case .fetch: return .yellow
        case .other: return .gray
        }
    }
}

// MARK: - Exercise Intensity

enum ExerciseIntensity: String, Codable {
    case low = "Düşük"
    case moderate = "Orta"
    case high = "Yüksek"

    var icon: String {
        switch self {
        case .low: return "🟢"
        case .moderate: return "🟡"
        case .high: return "🔴"
        }
    }
}

// MARK: - Exercise Model

@Model
final class Exercise {
    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var type: ExerciseType
    var title: String
    var startDate: Date
    var endDate: Date
    var duration: Int // Süre (dakika cinsinden)
    var distance: Double // Kilometre cinsinden
    var calories: Int // Yakılan kalori (tahmini)
    var intensity: ExerciseIntensity
    var notes: String
    var routeData: Data? // GPS route data (gelecekte kullanılacak)
    var averageSpeed: Double // km/h cinsinden
    var createdAt: Date

    // MARK: - Relationships

    var pet: Pet?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        type: ExerciseType,
        title: String = "",
        startDate: Date,
        endDate: Date,
        distance: Double = 0.0,
        calories: Int = 0,
        intensity: ExerciseIntensity = .moderate,
        notes: String = "",
        routeData: Data? = nil,
        pet: Pet? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title.isEmpty ? type.rawValue : title
        self.startDate = startDate
        self.endDate = endDate

        // Calculate duration first
        let calculatedDuration = Int(endDate.timeIntervalSince(startDate) / 60)
        self.duration = calculatedDuration

        self.distance = distance
        self.calories = calories
        self.intensity = intensity
        self.notes = notes
        self.routeData = routeData

        // Now we can safely use duration
        self.averageSpeed = calculatedDuration > 0 ? (distance / Double(calculatedDuration)) * 60 : 0
        self.createdAt = Date()
        self.pet = pet
    }
}

// MARK: - Computed Properties

extension Exercise {
    /// Süre string formatında (örn: "25 dk")
    var durationString: String {
        if duration >= 60 {
            let hours = duration / 60
            let minutes = duration % 60
            return minutes > 0 ? "\(hours) sa \(minutes) dk" : "\(hours) sa"
        } else {
            return "\(duration) dk"
        }
    }

    /// Mesafe string formatında (örn: "2.5 km")
    var distanceString: String {
        if distance >= 1.0 {
            return String(format: "%.1f km", distance)
        } else if distance > 0 {
            return String(format: "%.0f m", distance * 1000)
        } else {
            return "0 km"
        }
    }

    /// Kalori string formatında
    var caloriesString: String {
        "\(calories) kcal"
    }

    /// Hız string formatında
    var speedString: String {
        String(format: "%.1f km/h", averageSpeed)
    }

    /// Başlangıç tarihi string formatında
    var startDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: startDate)
    }

    /// Başlangıç saati string formatında
    var startTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: startDate)
    }
}

// MARK: - Methods

extension Exercise {
    /// Yakılan kaloriyi hesapla (basit formül)
    /// Pet'in kilosu ve egzersiz süresine göre tahmini
    func calculateCalories(petWeight: Double) -> Int {
        // Basit kalori hesaplama formülü
        // Gerçek uygulamada daha gelişmiş formül kullanılabilir
        let baseCaloriesPerMinute: Double

        switch intensity {
        case .low:
            baseCaloriesPerMinute = 3.0
        case .moderate:
            baseCaloriesPerMinute = 5.0
        case .high:
            baseCaloriesPerMinute = 8.0
        }

        // Kilo faktörü (ortalama 30kg için normalize)
        let weightFactor = petWeight / 30.0

        let totalCalories = baseCaloriesPerMinute * Double(duration) * weightFactor
        return Int(totalCalories)
    }
}

// MARK: - Sample Data

extension Exercise {
    /// Mock data için örnek egzersiz
    static var sample: Exercise {
        let now = Date()
        let start = Calendar.current.date(byAdding: .hour, value: -1, to: now) ?? now

        return Exercise(
            type: .walk,
            title: "Sabah Yürüyüşü",
            startDate: start,
            endDate: now,
            distance: 2.5,
            calories: 150,
            intensity: .moderate,
            notes: "Parkta güzel bir yürüyüş"
        )
    }

    /// Mock data için örnek egzersizler
    static var samples: [Exercise] {
        let now = Date()
        let calendar = Calendar.current

        return [
            Exercise(
                type: .walk,
                title: "Sabah Yürüyüşü",
                startDate: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
                endDate: calendar.date(byAdding: .hour, value: -1, to: now) ?? now,
                distance: 2.5,
                calories: 150,
                intensity: .moderate,
                notes: "Parkta rahat bir yürüyüş"
            ),
            Exercise(
                type: .run,
                title: "Hızlı Koşu",
                startDate: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                endDate: calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .minute, value: 30, to: now)!) ?? now,
                distance: 4.2,
                calories: 280,
                intensity: .high,
                notes: "Enerjik bir koşu"
            ),
            Exercise(
                type: .play,
                title: "Top Oyunu",
                startDate: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                endDate: calendar.date(byAdding: .day, value: -2, to: calendar.date(byAdding: .minute, value: 20, to: now)!) ?? now,
                distance: 0.5,
                calories: 80,
                intensity: .moderate,
                notes: "Bahçede top oynadık"
            ),
            Exercise(
                type: .walk,
                title: "Akşam Gezintisi",
                startDate: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                endDate: calendar.date(byAdding: .day, value: -3, to: calendar.date(byAdding: .minute, value: 45, to: now)!) ?? now,
                distance: 3.0,
                calories: 180,
                intensity: .low,
                notes: "Sahil yürüyüşü"
            ),
            Exercise(
                type: .training,
                title: "Eğitim Seansı",
                startDate: calendar.date(byAdding: .day, value: -4, to: now) ?? now,
                endDate: calendar.date(byAdding: .day, value: -4, to: calendar.date(byAdding: .minute, value: 15, to: now)!) ?? now,
                distance: 0.0,
                calories: 50,
                intensity: .low,
                notes: "Temel komutlar çalışıldı"
            )
        ]
    }
}

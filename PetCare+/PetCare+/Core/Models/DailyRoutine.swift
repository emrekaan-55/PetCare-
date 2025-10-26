//
//  DailyRoutine.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import Foundation
import SwiftData

// MARK: - Routine Type

enum RoutineType: String, Codable, CaseIterable {
    case feeding = "Yemek"
    case water = "Su"
    case bathroom = "Tuvalet"
    case exercise = "Egzersiz"
    case medication = "İlaç"
    case grooming = "Bakım"
    case playtime = "Oyun"
    case training = "Eğitim"

    var icon: String {
        switch self {
        case .feeding: return "fork.knife"
        case .water: return "drop.fill"
        case .bathroom: return "toilet.fill"
        case .exercise: return "figure.walk"
        case .medication: return "pills.fill"
        case .grooming: return "comb.fill"
        case .playtime: return "theatermasks.fill"
        case .training: return "book.fill"
        }
    }

    var color: String {
        switch self {
        case .feeding: return "orange"
        case .water: return "blue"
        case .bathroom: return "brown"
        case .exercise: return "green"
        case .medication: return "red"
        case .grooming: return "purple"
        case .playtime: return "pink"
        case .training: return "indigo"
        }
    }
}

// MARK: - Routine Status

enum RoutineStatus: String, Codable {
    case pending = "Bekliyor"
    case completed = "Tamamlandı"
    case skipped = "Atlandı"
    case late = "Geç"

    var icon: String {
        switch self {
        case .pending: return "clock"
        case .completed: return "checkmark.circle.fill"
        case .skipped: return "xmark.circle.fill"
        case .late: return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Daily Routine Model

@Model
final class DailyRoutine {
    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var title: String
    var type: RoutineType
    var scheduledTime: Date // Planland saat
    var duration: Int // Süre (dakika cinsinden)
    var isCompleted: Bool
    var completedAt: Date?
    var status: RoutineStatus
    var notes: String
    var isActive: Bool // Routine aktif mi (silinmeden devre dışı bırakma)
    var isRecurring: Bool // Tekrarlanan routine mu
    var recurringDays: [Int] // Haftanın günleri (1=Pazartesi, 7=Pazar), boşsa her gün
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Relationships

    var pet: Pet?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        title: String,
        type: RoutineType,
        scheduledTime: Date,
        duration: Int = 15,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        status: RoutineStatus = .pending,
        notes: String = "",
        isActive: Bool = true,
        isRecurring: Bool = false,
        recurringDays: [Int] = [],
        pet: Pet? = nil
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.scheduledTime = scheduledTime
        self.duration = duration
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.status = status
        self.notes = notes
        self.isActive = isActive
        self.isRecurring = isRecurring
        self.recurringDays = recurringDays
        self.createdAt = Date()
        self.updatedAt = Date()
        self.pet = pet
    }
}

// MARK: - Computed Properties

extension DailyRoutine {
    /// Scheduled time'ı string formatında döner
    var scheduledTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: scheduledTime)
    }

    /// Routine geç mi kontrolü
    var isLate: Bool {
        guard !isCompleted else { return false }
        return Date() > scheduledTime
    }

    /// Auto status update
    var currentStatus: RoutineStatus {
        if isCompleted {
            return .completed
        } else if isLate {
            return .late
        } else {
            return .pending
        }
    }

    /// Recurring days string (örn: "Pzt, Çar, Cum")
    var recurringDaysString: String {
        guard !recurringDays.isEmpty else { return "Her gün" }

        let dayNames = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]
        let selectedDays = recurringDays.sorted().compactMap { day -> String? in
            guard day >= 1 && day <= 7 else { return nil }
            return dayNames[day - 1]
        }

        return selectedDays.joined(separator: ", ")
    }
}

// MARK: - Methods

extension DailyRoutine {
    /// Routine'i tamamla
    func complete() {
        isCompleted = true
        completedAt = Date()
        status = .completed
        updatedAt = Date()
    }

    /// Routine'i atla
    func skip() {
        status = .skipped
        updatedAt = Date()
    }

    /// Routine'i sıfırla
    func reset() {
        isCompleted = false
        completedAt = nil
        status = .pending
        updatedAt = Date()
    }
}

// MARK: - Sample Data

extension DailyRoutine {
    /// Mock data için örnek routine
    static var sample: DailyRoutine {
        let now = Date()
        let calendar = Calendar.current
        let scheduledTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now) ?? now

        return DailyRoutine(
            title: "Sabah Kahvaltısı",
            type: .feeding,
            scheduledTime: scheduledTime,
            duration: 15,
            notes: "Kuru mama + ıslak mama karışımı"
        )
    }

    /// Mock data için örnek routine'ler
    static var samples: [DailyRoutine] {
        let now = Date()
        let calendar = Calendar.current

        return [
            DailyRoutine(
                title: "Sabah Kahvaltısı",
                type: .feeding,
                scheduledTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now) ?? now,
                duration: 15,
                notes: "Kuru mama + ıslak mama"
            ),
            DailyRoutine(
                title: "Su Değişimi",
                type: .water,
                scheduledTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now) ?? now,
                duration: 5,
                isCompleted: true,
                completedAt: calendar.date(bySettingHour: 9, minute: 15, second: 0, of: now),
                status: .completed
            ),
            DailyRoutine(
                title: "Sabah Yürüyüşü",
                type: .exercise,
                scheduledTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now) ?? now,
                duration: 30
            ),
            DailyRoutine(
                title: "Öğle Yemeği",
                type: .feeding,
                scheduledTime: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: now) ?? now,
                duration: 15
            ),
            DailyRoutine(
                title: "Tuvalet Temizliği",
                type: .bathroom,
                scheduledTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now) ?? now,
                duration: 10,
                isRecurring: true
            ),
            DailyRoutine(
                title: "Oyun Zamanı",
                type: .playtime,
                scheduledTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now) ?? now,
                duration: 20
            ),
            DailyRoutine(
                title: "Akşam Yemeği",
                type: .feeding,
                scheduledTime: calendar.date(bySettingHour: 19, minute: 0, second: 0, of: now) ?? now,
                duration: 15
            ),
            DailyRoutine(
                title: "Tırnak Bakımı",
                type: .grooming,
                scheduledTime: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now,
                duration: 10,
                isRecurring: true,
                recurringDays: [1, 4, 7] // Pzt, Per, Paz
            )
        ]
    }
}

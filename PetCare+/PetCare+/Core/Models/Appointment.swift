//
//  Appointment.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Appointment Type

enum AppointmentType: String, Codable, CaseIterable {
    case veterinary = "Veteriner"
    case grooming = "Tıraş/Bakım"
    case vaccination = "Aşı"
    case checkup = "Kontrol"
    case surgery = "Ameliyat"
    case dental = "Diş"
    case other = "Diğer"

    var icon: String {
        switch self {
        case .veterinary: return "cross.case.fill"
        case .grooming: return "scissors"
        case .vaccination: return "syringe.fill"
        case .checkup: return "stethoscope"
        case .surgery: return "bed.double.fill"
        case .dental: return "tooth.fill"
        case .other: return "calendar.badge.plus"
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .veterinary: return .blue
        case .grooming: return .purple
        case .vaccination: return .green
        case .checkup: return .orange
        case .surgery: return .red
        case .dental: return .cyan
        case .other: return .gray
        }
    }
}

// MARK: - Appointment Status

enum AppointmentStatus: String, Codable {
    case upcoming = "Yaklaşan"
    case completed = "Tamamlandı"
    case cancelled = "İptal"
    case missed = "Kaçırıldı"

    var icon: String {
        switch self {
        case .upcoming: return "clock.fill"
        case .completed: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        case .missed: return "exclamationmark.triangle.fill"
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .upcoming: return .blue
        case .completed: return .green
        case .cancelled: return .gray
        case .missed: return .red
        }
    }
}

// MARK: - Appointment Model

@Model
final class Appointment {
    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var type: AppointmentType
    var title: String
    var date: Date
    var duration: Int // Süre (dakika)
    var location: String
    var veterinarianName: String
    var notes: String
    var status: AppointmentStatus
    var reminderMinutesBefore: Int // Kaç dakika önce hatırlatma
    var cost: Double
    var createdAt: Date

    // MARK: - Relationships

    var pet: Pet?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        type: AppointmentType,
        title: String = "",
        date: Date,
        duration: Int = 30,
        location: String = "",
        veterinarianName: String = "",
        notes: String = "",
        status: AppointmentStatus = .upcoming,
        reminderMinutesBefore: Int = 60,
        cost: Double = 0.0,
        pet: Pet? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title.isEmpty ? type.rawValue : title
        self.date = date
        self.duration = duration
        self.location = location
        self.veterinarianName = veterinarianName
        self.notes = notes
        self.status = status
        self.reminderMinutesBefore = reminderMinutesBefore
        self.cost = cost
        self.createdAt = Date()
        self.pet = pet
    }
}

// MARK: - Computed Properties

extension Appointment {
    /// Randevu geçti mi?
    var isPast: Bool {
        date < Date()
    }

    /// Randevu bugün mü?
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    /// Randevu bu hafta mı?
    var isThisWeek: Bool {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: now) + 1, to: now),
              let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
            return false
        }
        return date >= weekStart && date < weekEnd
    }

    /// Tarih string formatında
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    /// Tarih (sadece gün)
    var dateOnlyString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    /// Saat
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    /// Süre string formatında
    var durationString: String {
        if duration >= 60 {
            let hours = duration / 60
            let minutes = duration % 60
            return minutes > 0 ? "\(hours) sa \(minutes) dk" : "\(hours) sa"
        } else {
            return "\(duration) dk"
        }
    }

    /// Maliyet string formatında
    var costString: String {
        if cost > 0 {
            return String(format: "%.2f ₺", cost)
        } else {
            return "Belirtilmedi"
        }
    }

    /// Randevuya kalan süre
    var timeUntil: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: Date(), to: date)

        if let days = components.day, days > 0 {
            return "\(days) gün sonra"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) saat sonra"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) dakika sonra"
        } else {
            return "Şimdi"
        }
    }
}

// MARK: - Methods

extension Appointment {
    /// Randevuyu tamamla
    func complete() {
        status = .completed
    }

    /// Randevuyu iptal et
    func cancel() {
        status = .cancelled
    }

    /// Randevuyu kaçırıldı olarak işaretle
    func markAsMissed() {
        status = .missed
    }

    /// Durumu güncelle (geçmiş randevular için)
    func updateStatusIfNeeded() {
        guard status == .upcoming, isPast else { return }
        status = .missed
    }
}

// MARK: - Sample Data

extension Appointment {
    /// Mock data için örnek randevu
    static var sample: Appointment {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()

        return Appointment(
            type: .veterinary,
            title: "Yıllık Kontrol",
            date: tomorrow,
            duration: 30,
            location: "Pati Veteriner Kliniği",
            veterinarianName: "Dr. Ayşe Demir",
            notes: "Yıllık aşı kontrolü ve genel muayene",
            reminderMinutesBefore: 120,
            cost: 350.0
        )
    }

    /// Mock data için örnek randevular
    static var samples: [Appointment] {
        let calendar = Calendar.current
        let now = Date()

        return [
            Appointment(
                type: .vaccination,
                title: "Kuduz Aşısı",
                date: calendar.date(byAdding: .day, value: 2, to: now) ?? now,
                duration: 15,
                location: "Pati Veteriner Kliniği",
                veterinarianName: "Dr. Mehmet Yılmaz",
                notes: "Yıllık kuduz aşısı",
                cost: 150.0
            ),
            Appointment(
                type: .grooming,
                title: "Tıraş ve Bakım",
                date: calendar.date(byAdding: .day, value: 5, to: now) ?? now,
                duration: 60,
                location: "Happy Pets Grooming",
                veterinarianName: "",
                notes: "Tam tıraş ve tırnak kesimi",
                cost: 200.0
            ),
            Appointment(
                type: .checkup,
                title: "Kontrol Muayenesi",
                date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                duration: 30,
                location: "Şifa Veteriner",
                veterinarianName: "Dr. Zeynep Kaya",
                notes: "Genel sağlık kontrolü",
                status: .completed,
                cost: 250.0
            ),
            Appointment(
                type: .dental,
                title: "Diş Temizliği",
                date: calendar.date(byAdding: .day, value: 10, to: now) ?? now,
                duration: 45,
                location: "Pet Dental",
                veterinarianName: "Dr. Can Öztürk",
                notes: "Ultrasonik diş temizliği",
                cost: 400.0
            )
        ]
    }
}

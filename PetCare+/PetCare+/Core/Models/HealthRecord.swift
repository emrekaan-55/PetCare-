//
//  HealthRecord.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import Foundation
import SwiftData

// MARK: - Health Record Type

enum HealthRecordType: String, Codable, CaseIterable {
    case vaccination = "Aşı"
    case checkup = "Genel Muayene"
    case medication = "İlaç"
    case surgery = "Ameliyat"
    case dental = "Diş Bakımı"
    case laboratory = "Laboratuvar"
    case emergency = "Acil"
    case other = "Diğer"

    var icon: String {
        switch self {
        case .vaccination: return "syringe.fill"
        case .checkup: return "stethoscope"
        case .medication: return "pills.fill"
        case .surgery: return "cross.case.fill"
        case .dental: return "mouth.fill"
        case .laboratory: return "testtube.2"
        case .emergency: return "exclamationmark.triangle.fill"
        case .other: return "doc.text.fill"
        }
    }

    var color: String {
        switch self {
        case .vaccination: return "green"
        case .checkup: return "blue"
        case .medication: return "orange"
        case .surgery: return "red"
        case .dental: return "purple"
        case .laboratory: return "indigo"
        case .emergency: return "red"
        case .other: return "gray"
        }
    }
}

// MARK: - Health Record Model

@Model
final class HealthRecord {
    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var type: HealthRecordType
    var title: String
    var recordDate: Date
    var veterinarianName: String
    var clinicName: String
    var diagnosis: String
    var treatment: String
    var notes: String
    var cost: Double // TL cinsinden
    var nextAppointment: Date? // Sonraki randevu tarihi
    var attachmentData: Data? // Dosya/rapor eklentisi
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Relationships

    var pet: Pet?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        type: HealthRecordType,
        title: String,
        recordDate: Date,
        veterinarianName: String = "",
        clinicName: String = "",
        diagnosis: String = "",
        treatment: String = "",
        notes: String = "",
        cost: Double = 0.0,
        nextAppointment: Date? = nil,
        attachmentData: Data? = nil,
        pet: Pet? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.recordDate = recordDate
        self.veterinarianName = veterinarianName
        self.clinicName = clinicName
        self.diagnosis = diagnosis
        self.treatment = treatment
        self.notes = notes
        self.cost = cost
        self.nextAppointment = nextAppointment
        self.attachmentData = attachmentData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.pet = pet
    }
}

// MARK: - Computed Properties

extension HealthRecord {
    /// Tarih string formatında
    var recordDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: recordDate)
    }

    /// Sonraki randevu string formatında
    var nextAppointmentString: String? {
        guard let nextAppointment else { return nil }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: nextAppointment)
    }

    /// Maliyet string formatında (TL)
    var costString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: cost)) ?? "₺0"
    }

    /// Sonraki randevu yaklaşıyor mu?
    var isNextAppointmentSoon: Bool {
        guard let nextAppointment else { return false }
        let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: nextAppointment).day ?? 0
        return daysUntil >= 0 && daysUntil <= 7
    }
}

// MARK: - Sample Data

extension HealthRecord {
    /// Mock data için örnek kayıt
    static var sample: HealthRecord {
        HealthRecord(
            type: .vaccination,
            title: "Karma Aşı (5'li)",
            recordDate: Date(),
            veterinarianName: "Dr. Ahmet Yılmaz",
            clinicName: "Yıldız Veteriner Kliniği",
            diagnosis: "Sağlıklı",
            treatment: "Karma aşı uygulandı",
            notes: "1 yıl sonra tekrar hatırlatıcı ayarla",
            cost: 350.0,
            nextAppointment: Calendar.current.date(byAdding: .year, value: 1, to: Date())
        )
    }

    /// Mock data için örnek kayıtlar
    static var samples: [HealthRecord] {
        [
            HealthRecord(
                type: .vaccination,
                title: "Karma Aşı (5'li)",
                recordDate: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date(),
                veterinarianName: "Dr. Ahmet Yılmaz",
                clinicName: "Yıldız Veteriner Kliniği",
                diagnosis: "Sağlıklı",
                treatment: "Karma aşı uygulandı",
                notes: "1 yıl sonra tekrar",
                cost: 350.0,
                nextAppointment: Calendar.current.date(byAdding: .month, value: 10, to: Date())
            ),
            HealthRecord(
                type: .checkup,
                title: "Yıllık Kontrol",
                recordDate: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
                veterinarianName: "Dr. Ayşe Kaya",
                clinicName: "Mutlu Patiler Kliniği",
                diagnosis: "Genel sağlık durumu iyi",
                treatment: "Kilo kontrolü yapıldı, diş bakımı önerildi",
                notes: "6 ay sonra diş temizliği için randevu",
                cost: 250.0,
                nextAppointment: Calendar.current.date(byAdding: .month, value: 5, to: Date())
            ),
            HealthRecord(
                type: .dental,
                title: "Diş Taşı Temizliği",
                recordDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
                veterinarianName: "Dr. Mehmet Demir",
                clinicName: "Yıldız Veteriner Kliniği",
                diagnosis: "Diş taşı birikimi",
                treatment: "Ultrasonik diş temizliği yapıldı",
                notes: "1 yıl sonra kontrol",
                cost: 800.0
            ),
            HealthRecord(
                type: .medication,
                title: "Parazit İlacı",
                recordDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
                veterinarianName: "Dr. Ahmet Yılmaz",
                clinicName: "Yıldız Veteriner Kliniği",
                diagnosis: "Rutin korunma",
                treatment: "İç parazit ilacı verildi",
                notes: "3 ayda bir tekrar",
                cost: 120.0,
                nextAppointment: Calendar.current.date(byAdding: .month, value: 3, to: Date())
            ),
            HealthRecord(
                type: .laboratory,
                title: "Kan Tahlili",
                recordDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
                veterinarianName: "Dr. Ayşe Kaya",
                clinicName: "Mutlu Patiler Kliniği",
                diagnosis: "Tüm değerler normal aralıkta",
                treatment: "Tedavi gerekmedi",
                notes: "Yıllık rutin kontrol",
                cost: 450.0
            )
        ]
    }
}

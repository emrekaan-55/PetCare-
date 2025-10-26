//
//  MockDataService.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import Foundation
import SwiftData

/// Mock data servis - Geliştirme ve test için örnek veriler sağlar
@MainActor
class MockDataService {
    // MARK: - Singleton

    static let shared = MockDataService()

    private init() {}

    // MARK: - Mock Data Creation

    /// SwiftData context'e mock data ekle
    func populateMockData(context: ModelContext) {
        // Önce mevcut datayı temizle (opsiyonel)
        // clearAllData(context: context)

        // Örnek petleri oluştur
        let pets = createMockPets()

        // Petleri context'e ekle
        for pet in pets {
            context.insert(pet)
        }

        // Her pet için routines, health records ve exercises ekle
        for pet in pets {
            let routines = createMockRoutines(for: pet)
            let healthRecords = createMockHealthRecords(for: pet)
            let exercises = createMockExercises(for: pet)

            routines.forEach { context.insert($0) }
            healthRecords.forEach { context.insert($0) }
            exercises.forEach { context.insert($0) }

            pet.routines = routines
            pet.healthRecords = healthRecords
            pet.exercises = exercises
        }

        // Değişiklikleri kaydet
        try? context.save()
    }

    // MARK: - Create Mock Pets

    private func createMockPets() -> [Pet] {
        [
            Pet(
                name: "Karamel",
                species: .cat,
                breed: "British Shorthair",
                gender: .female,
                birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
                weight: 4.5,
                notes: "Çok tatlı ve oyuncu bir kedi. Oyuncak farelerle oynamayı çok sever."
            ),
            Pet(
                name: "Max",
                species: .dog,
                breed: "Golden Retriever",
                gender: .male,
                birthDate: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
                weight: 30.0,
                notes: "Enerjik ve sadık bir köpek. Su oyunlarını çok sever."
            ),
            Pet(
                name: "Luna",
                species: .cat,
                breed: "Scottish Fold",
                gender: .female,
                birthDate: Calendar.current.date(byAdding: .month, value: -8, to: Date())!,
                weight: 3.2,
                notes: "Uysal ve sakin. Yüksek yerlerde uyumayı sever."
            )
        ]
    }

    // MARK: - Create Mock Routines

    private func createMockRoutines(for pet: Pet) -> [DailyRoutine] {
        let now = Date()
        let calendar = Calendar.current

        var routines: [DailyRoutine] = []

        // Sabah rutinleri
        routines.append(DailyRoutine(
            title: "Sabah Kahvaltısı",
            type: .feeding,
            scheduledTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
            duration: 15,
            isCompleted: true,
            completedAt: calendar.date(bySettingHour: 8, minute: 10, second: 0, of: now),
            status: .completed,
            notes: pet.species == .cat ? "Kuru mama + ıslak mama" : "Yetişkin köpek maması",
            pet: pet
        ))

        routines.append(DailyRoutine(
            title: "Su Değişimi",
            type: .water,
            scheduledTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!,
            duration: 5,
            isCompleted: true,
            completedAt: calendar.date(bySettingHour: 9, minute: 5, second: 0, of: now),
            status: .completed,
            pet: pet
        ))

        // Öğle rutinleri
        if pet.species == .dog {
            routines.append(DailyRoutine(
                title: "Sabah Yürüyüşü",
                type: .exercise,
                scheduledTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                duration: 30,
                isCompleted: false,
                notes: "Park veya sahil",
                pet: pet
            ))
        }

        routines.append(DailyRoutine(
            title: "Öğle Yemeği",
            type: .feeding,
            scheduledTime: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: now)!,
            duration: 15,
            isCompleted: false,
            pet: pet
        ))

        // Öğleden sonra
        routines.append(DailyRoutine(
            title: "Tuvalet Temizliği",
            type: .bathroom,
            scheduledTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
            duration: 10,
            isCompleted: false,
            isRecurring: true,
            pet: pet
        ))

        routines.append(DailyRoutine(
            title: "Oyun Zamanı",
            type: .playtime,
            scheduledTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!,
            duration: 20,
            isCompleted: false,
            notes: pet.species == .cat ? "Lazer ve oyuncak fare" : "Top ve ip oyunları",
            pet: pet
        ))

        // Akşam rutinleri
        routines.append(DailyRoutine(
            title: "Akşam Yemeği",
            type: .feeding,
            scheduledTime: calendar.date(bySettingHour: 19, minute: 0, second: 0, of: now)!,
            duration: 15,
            isCompleted: false,
            pet: pet
        ))

        if pet.species == .dog {
            routines.append(DailyRoutine(
                title: "Akşam Yürüyüşü",
                type: .exercise,
                scheduledTime: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
                duration: 25,
                isCompleted: false,
                pet: pet
            ))
        }

        return routines
    }

    // MARK: - Create Mock Health Records

    private func createMockHealthRecords(for pet: Pet) -> [HealthRecord] {
        [
            HealthRecord(
                type: .vaccination,
                title: "Karma Aşı (5'li)",
                recordDate: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
                veterinarianName: "Dr. Ahmet Yılmaz",
                clinicName: "Yıldız Veteriner Kliniği",
                diagnosis: "Sağlıklı",
                treatment: "Karma aşı uygulandı",
                notes: "1 yıl sonra tekrar hatırlatıcı",
                cost: 350.0,
                nextAppointment: Calendar.current.date(byAdding: .month, value: 10, to: Date()),
                pet: pet
            ),
            HealthRecord(
                type: .checkup,
                title: "Yıllık Kontrol",
                recordDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
                veterinarianName: "Dr. Ayşe Kaya",
                clinicName: "Mutlu Patiler Kliniği",
                diagnosis: "Genel sağlık durumu iyi",
                treatment: "Kilo kontrolü yapıldı",
                notes: "6 ay sonra diş kontrolü önerildi",
                cost: 250.0,
                nextAppointment: Calendar.current.date(byAdding: .month, value: 5, to: Date()),
                pet: pet
            ),
            HealthRecord(
                type: .medication,
                title: "Parazit İlacı",
                recordDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                veterinarianName: "Dr. Ahmet Yılmaz",
                clinicName: "Yıldız Veteriner Kliniği",
                diagnosis: "Rutin korunma",
                treatment: "İç parazit ilacı verildi",
                notes: "3 ayda bir tekrar",
                cost: 120.0,
                nextAppointment: Calendar.current.date(byAdding: .month, value: 3, to: Date()),
                pet: pet
            )
        ]
    }

    // MARK: - Create Mock Exercises

    private func createMockExercises(for pet: Pet) -> [Exercise] {
        guard pet.species == .dog else { return [] } // Sadece köpekler için egzersiz

        let now = Date()
        let calendar = Calendar.current

        return [
            Exercise(
                type: .walk,
                title: "Sabah Yürüyüşü",
                startDate: calendar.date(byAdding: .hour, value: -2, to: now)!,
                endDate: calendar.date(byAdding: .hour, value: -1, to: now)!,
                distance: 2.5,
                calories: 150,
                intensity: .moderate,
                notes: "Parkta rahat bir yürüyüş",
                pet: pet
            ),
            Exercise(
                type: .run,
                title: "Hızlı Koşu",
                startDate: calendar.date(byAdding: .day, value: -1, to: now)!,
                endDate: calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .minute, value: 30, to: now)!)!,
                distance: 4.2,
                calories: 280,
                intensity: .high,
                notes: "Enerjik bir koşu",
                pet: pet
            ),
            Exercise(
                type: .play,
                title: "Top Oyunu",
                startDate: calendar.date(byAdding: .day, value: -2, to: now)!,
                endDate: calendar.date(byAdding: .day, value: -2, to: calendar.date(byAdding: .minute, value: 20, to: now)!)!,
                distance: 0.5,
                calories: 80,
                intensity: .moderate,
                notes: "Bahçede top oynadık",
                pet: pet
            )
        ]
    }

    // MARK: - Clear Data

    /// Tüm mock datayı temizle (dikkatli kullan!)
    func clearAllData(context: ModelContext) {
        do {
            try context.delete(model: Pet.self)
            try context.delete(model: DailyRoutine.self)
            try context.delete(model: HealthRecord.self)
            try context.delete(model: Exercise.self)
            try context.save()
        } catch {
            print("Error clearing data: \(error)")
        }
    }
}

//
//  PetCare_App.swift
//  PetCare+
//
//  Created by Emre Kaan on 25.10.2025.
//

import SwiftUI
import SwiftData

@main
struct PetCarePlusApp: App {
    // MARK: - Model Container

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pet.self,
            DailyRoutine.self,
            HealthRecord.self,
            Exercise.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Mock data yükle (sadece ilk açılışta veya debug modda)
            #if DEBUG
            Task { @MainActor in
                let context = container.mainContext
                // Eğer hiç pet yoksa mock data yükle
                let descriptor = FetchDescriptor<Pet>()
                let petCount = (try? context.fetchCount(descriptor)) ?? 0

                if petCount == 0 {
                    MockDataService.shared.populateMockData(context: context)
                    print("✅ Mock data yüklendi!")
                }
            }
            #endif

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(AppColors.accent)
        }
        .modelContainer(sharedModelContainer)
    }
}

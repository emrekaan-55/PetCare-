//
//  DailyRoutineViewModel.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
class DailyRoutineViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var routines: [DailyRoutine] = []
    @Published var filteredRoutines: [DailyRoutine] = []
    @Published var selectedFilter: RoutineFilter = .all
    @Published var isLoading = false
    @Published var searchText = ""

    // MARK: - Filter Enum

    enum RoutineFilter: String, CaseIterable {
        case all = "Tümü"
        case pending = "Bekleyen" 
        case completed = "Tamamlanan"
        case late = "Geç"

        var icon: String {
            switch self {
            case .all: return "list.bullet"
            case .pending: return "clock"
            case .completed: return "checkmark.circle.fill"
            case .late: return "exclamationmark.triangle.fill"
            }
        }
    }

    // MARK: - Properties

    private let context: ModelContext
    private var currentPet: Pet?

    // MARK: - Computed Properties

    var todayProgress: Double {
        guard !routines.isEmpty else { return 0 }
        let completed = routines.filter { $0.isCompleted }.count
        return Double(completed) / Double(routines.count)
    }

    var completedCount: Int {
        routines.filter { $0.isCompleted }.count
    }

    var pendingCount: Int {
        routines.filter { !$0.isCompleted && !$0.isLate }.count
    }

    var lateCount: Int {
        routines.filter { $0.isLate }.count
    }

    // MARK: - Initialization

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Methods

    /// Routine'leri yükle
    func loadRoutines(for pet: Pet) {
        isLoading = true
        currentPet = pet
        routines = pet.routines.filter { $0.isActive }
        applyFilter()
        isLoading = false
    }

    /// Filter uygula
    func applyFilter() {
        var filtered = routines

        // Filter type'a göre
        switch selectedFilter {
        case .all:
            break
        case .pending:
            filtered = filtered.filter { !$0.isCompleted && !$0.isLate }
        case .completed:
            filtered = filtered.filter { $0.isCompleted }
        case .late:
            filtered = filtered.filter { $0.isLate }
        }

        // Search text'e göre
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Scheduled time'a göre sırala
        filtered.sort { $0.scheduledTime < $1.scheduledTime }

        filteredRoutines = filtered
    }

    /// Routine'i tamamla
    func completeRoutine(_ routine: DailyRoutine) {
        routine.complete()
        saveContext()
        applyFilter()
    }

    /// Routine'i atla
    func skipRoutine(_ routine: DailyRoutine) {
        routine.skip()
        saveContext()
        applyFilter()
    }

    /// Routine'i sıfırla
    func resetRoutine(_ routine: DailyRoutine) {
        routine.reset()
        saveContext()
        applyFilter()
    }

    /// Routine sil
    func deleteRoutine(_ routine: DailyRoutine) {
        context.delete(routine)
        saveContext()
        if let currentPet {
            loadRoutines(for: currentPet)
        }
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

//
//  ExerciseViewModel.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
class ExerciseViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var exercises: [Exercise] = []
    @Published var filteredExercises: [Exercise] = []
    @Published var selectedFilter: ExerciseFilter = .all
    @Published var isLoading = false
    @Published var searchText = ""

    // Active exercise tracking
    @Published var activeExercise: Exercise?
    @Published var isExerciseActive = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var isPaused = false

    // MARK: - Filter Enum

    enum ExerciseFilter: String, CaseIterable {
        case all = "Tümü"
        case walk = "Yürüyüş"
        case run = "Koşu"
        case play = "Oyun"
        case training = "Eğitim"

        var icon: String {
            switch self {
            case .all: return "list.bullet"
            case .walk: return "figure.walk"
            case .run: return "figure.run"
            case .play: return "sportscourt"
            case .training: return "figure.strengthtraining.traditional"
            }
        }

        var exerciseType: ExerciseType? {
            switch self {
            case .all: return nil
            case .walk: return .walk
            case .run: return .run
            case .play: return .play
            case .training: return .training
            }
        }
    }

    // MARK: - Properties

    private let context: ModelContext
    private var currentPet: Pet?
    private var timer: Timer?
    private var startDate: Date?

    // MARK: - Computed Properties

    var totalExercises: Int {
        exercises.count
    }

    var totalDuration: Int {
        exercises.reduce(0) { $0 + $1.duration }
    }

    var averageDuration: Int {
        guard !exercises.isEmpty else { return 0 }
        return totalDuration / exercises.count
    }

    var thisWeekExercises: [Exercise] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return exercises.filter { $0.startDate >= weekAgo }
    }

    var thisWeekDuration: Int {
        thisWeekExercises.reduce(0) { $0 + $1.duration }
    }

    // MARK: - Initialization

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Methods

    /// Exercise'ları yükle
    func loadExercises(for pet: Pet) {
        isLoading = true
        currentPet = pet
        exercises = pet.exercises.sorted { $0.startDate > $1.startDate }
        applyFilter()
        isLoading = false
    }

    /// Filter uygula
    func applyFilter() {
        var filtered = exercises

        // Filter type'a göre
        if let exerciseType = selectedFilter.exerciseType {
            filtered = filtered.filter { $0.type == exerciseType }
        }

        // Search text'e göre
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.notes.localizedCaseInsensitiveContains(searchText) ||
                $0.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        filteredExercises = filtered
    }

    /// Yeni exercise başlat
    func startExercise(type: ExerciseType) {
        guard let currentPet else { return }

        let now = Date()
        let exercise = Exercise(
            type: type,
            startDate: now,
            endDate: now,
            pet: currentPet
        )

        context.insert(exercise)
        activeExercise = exercise
        isExerciseActive = true
        isPaused = false
        elapsedTime = 0
        startDate = now

        startTimer()
    }

    /// Exercise'ı duraklat
    func pauseExercise() {
        isPaused = true
        stopTimer()
    }

    /// Exercise'ı devam ettir
    func resumeExercise() {
        isPaused = false
        startDate = Date().addingTimeInterval(-elapsedTime)
        startTimer()
    }

    /// Exercise'ı bitir
    func stopExercise(distance: Double? = nil, notes: String? = nil, intensity: ExerciseIntensity = .moderate) {
        guard let activeExercise else { return }

        stopTimer()

        let endDate = Date()
        activeExercise.endDate = endDate
        activeExercise.duration = Int(elapsedTime / 60) // Convert to minutes
        activeExercise.distance = distance ?? 0
        activeExercise.notes = notes ?? ""
        activeExercise.intensity = intensity

        // Calculate calories if pet weight is available
        if let petWeight = currentPet?.weight {
            activeExercise.calories = activeExercise.calculateCalories(petWeight: petWeight)
        }

        saveContext()

        // Reset state
        self.activeExercise = nil
        isExerciseActive = false
        isPaused = false
        elapsedTime = 0
        startDate = nil

        // Reload exercises
        if let currentPet {
            loadExercises(for: currentPet)
        }
    }

    /// Exercise'ı iptal et
    func cancelExercise() {
        guard let activeExercise else { return }

        stopTimer()
        context.delete(activeExercise)

        self.activeExercise = nil
        isExerciseActive = false
        isPaused = false
        elapsedTime = 0
        startDate = nil
    }

    /// Exercise sil
    func deleteExercise(_ exercise: Exercise) {
        context.delete(exercise)
        saveContext()
        if let currentPet {
            loadExercises(for: currentPet)
        }
    }

    /// Exercise güncelle
    func updateExercise(_ exercise: Exercise, distance: Double?, notes: String?) {
        exercise.distance = distance ?? 0
        exercise.notes = notes ?? ""
        saveContext()
        applyFilter()
    }

    // MARK: - Private Methods

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, let startDate = self.startDate else { return }
                self.elapsedTime = Date().timeIntervalSince(startDate)
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    // MARK: - Deinitializer

    nonisolated deinit {
        timer?.invalidate()
    }
}

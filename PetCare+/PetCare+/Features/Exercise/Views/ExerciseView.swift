//
//  ExerciseView.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI
import SwiftData

struct ExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ExerciseViewModel
    @Binding var selectedPet: Pet?

    @State private var showingAddExercise = false
    @State private var selectedExerciseType: Exercise.ExerciseType = .walking

    init(selectedPet: Binding<Pet?>) {
        self._selectedPet = selectedPet
        _viewModel = StateObject(wrappedValue: ExerciseViewModel(context: ModelContext(
            try! ModelContainer(for: Pet.self, DailyRoutine.self, Exercise.self, Appointment.self).mainContext
        )))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if let pet = selectedPet {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Stats Section
                            statsSection

                            // Quick Actions
                            quickActionsSection

                            // Filters
                            filterSection

                            // Exercise List
                            exerciseListSection
                        }
                        .padding()
                    }
                } else {
                    ContentUnavailableView(
                        "Evcil Hayvan Seçilmedi",
                        systemImage: "pawprint.fill",
                        description: Text("Egzersiz takibi için bir evcil hayvan seçin")
                    )
                }
            }
            .navigationTitle("Egzersiz")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedPet != nil {
                        Button {
                            showingAddExercise = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                if let pet = selectedPet {
                    AddExerciseSheet(
                        viewModel: viewModel,
                        pet: pet,
                        isPresented: $showingAddExercise
                    )
                }
            }
            .fullScreenCover(isPresented: $viewModel.isExerciseActive) {
                if viewModel.activeExercise != nil {
                    ExerciseSessionView(viewModel: viewModel)
                }
            }
        }
        .onChange(of: selectedPet) { oldValue, newValue in
            if let pet = newValue {
                viewModel.loadExercises(for: pet)
            }
        }
        .onChange(of: viewModel.searchText) { oldValue, newValue in
            viewModel.applyFilter()
        }
        .onChange(of: viewModel.selectedFilter) { oldValue, newValue in
            viewModel.applyFilter()
        }
        .onAppear {
            if let pet = selectedPet {
                viewModel.loadExercises(for: pet)
            }
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        VStack(spacing: 12) {
            Text("Bu Hafta")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                StatCard(
                    title: "Toplam Süre",
                    value: formatDuration(viewModel.thisWeekDuration),
                    icon: "clock.fill",
                    color: .blue
                )

                StatCard(
                    title: "Egzersiz",
                    value: "\(viewModel.thisWeekExercises.count)",
                    icon: "figure.run",
                    color: .green
                )

                StatCard(
                    title: "Ortalama",
                    value: formatDuration(viewModel.averageDuration),
                    icon: "chart.bar.fill",
                    color: .orange
                )
            }
        }
    }

    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            Text("Hızlı Başlat")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickExerciseButton(
                    title: "Yürüyüş",
                    icon: "figure.walk",
                    color: .blue
                ) {
                    viewModel.startExercise(type: .walking)
                }

                QuickExerciseButton(
                    title: "Koşu",
                    icon: "figure.run",
                    color: .green
                ) {
                    viewModel.startExercise(type: .running)
                }

                QuickExerciseButton(
                    title: "Oyun",
                    icon: "sportscourt",
                    color: .purple
                ) {
                    viewModel.startExercise(type: .playing)
                }

                QuickExerciseButton(
                    title: "Eğitim",
                    icon: "figure.strengthtraining.traditional",
                    color: .orange
                ) {
                    viewModel.startExercise(type: .training)
                }
            }
        }
    }

    // MARK: - Filter Section

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ExerciseViewModel.ExerciseFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        icon: filter.icon,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        viewModel.selectedFilter = filter
                    }
                }
            }
        }
    }

    // MARK: - Exercise List Section

    private var exerciseListSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Geçmiş Egzersizler")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.filteredExercises.count) egzersiz")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.filteredExercises.isEmpty {
                ContentUnavailableView(
                    "Egzersiz Yok",
                    systemImage: "figure.run.circle",
                    description: Text("Henüz egzersiz kaydı bulunmuyor")
                )
                .frame(height: 200)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredExercises) { exercise in
                        ExerciseCard(exercise: exercise) {
                            viewModel.deleteExercise(exercise)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60

        if hours > 0 {
            return "\(hours)s \(minutes)dk"
        } else {
            return "\(minutes)dk"
        }
    }
}

// MARK: - StatCard Component

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - QuickExerciseButton Component

struct QuickExerciseButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - AddExerciseSheet

struct AddExerciseSheet: View {
    @ObservedObject var viewModel: ExerciseViewModel
    let pet: Pet
    @Binding var isPresented: Bool

    @State private var selectedType: Exercise.ExerciseType = .walking

    var body: some View {
        NavigationStack {
            List {
                ForEach(Exercise.ExerciseType.allCases, id: \.self) { type in
                    Button {
                        viewModel.startExercise(type: type)
                        isPresented = false
                    } label: {
                        HStack {
                            Image(systemName: type.icon)
                                .foregroundStyle(type.color)
                                .frame(width: 30)
                            Text(type.rawValue)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Egzersiz Tipi Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

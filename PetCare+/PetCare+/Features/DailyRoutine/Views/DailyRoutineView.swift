//
//  DailyRoutineView.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI
import SwiftData

struct DailyRoutineView: View {
    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [Pet]
    @StateObject private var viewModel: DailyRoutineViewModel
    @State private var selectedPet: Pet?
    @State private var showingFilterMenu = false

    // MARK: - Initialization

    init() {
        // ModelContext'e erişim için geçici bir çözüm
        // Gerçek context onAppear'da set edilecek
        let container = try! ModelContainer(for: Pet.self, DailyRoutine.self)
        let context = container.mainContext
        _viewModel = StateObject(wrappedValue: DailyRoutineViewModel(context: context))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Header
                if !viewModel.routines.isEmpty {
                    progressHeader
                        .padding()
                }

                // Filter Chips
                filterChips
                    .padding(.horizontal)
                    .padding(.bottom)

                // Routines List
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.filteredRoutines.isEmpty {
                    emptyStateView
                } else {
                    routinesList
                }
            }
            .background(AppColors.background)
            .navigationTitle("Günlük Rutinler")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Add routine tapped")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
            .onAppear {
                if selectedPet == nil, let firstPet = pets.first {
                    selectedPet = firstPet
                    viewModel.loadRoutines(for: firstPet)
                }
            }
        }
    }

    // MARK: - Progress Header

    private var progressHeader: some View {
        VStack(spacing: AppSpacing.md) {
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(AppColors.gray5, lineWidth: 12)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: viewModel.todayProgress)
                    .stroke(
                        AppColors.accent,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: viewModel.todayProgress)

                VStack(spacing: 4) {
                    Text("\(viewModel.completedCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)

                    Text("/ \(viewModel.routines.count)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            // Stats
            HStack(spacing: AppSpacing.xl) {
                statBadge(
                    icon: "checkmark.circle.fill",
                    count: viewModel.completedCount,
                    label: "Tamamlanan",
                    color: AppColors.success
                )

                statBadge(
                    icon: "clock.fill",
                    count: viewModel.pendingCount,
                    label: "Bekleyen",
                    color: AppColors.info
                )

                if viewModel.lateCount > 0 {
                    statBadge(
                        icon: "exclamationmark.triangle.fill",
                        count: viewModel.lateCount,
                        label: "Geç",
                        color: AppColors.error
                    )
                }
            }
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(20)
    }

    // MARK: - Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(DailyRoutineViewModel.RoutineFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        filter: filter,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        viewModel.selectedFilter = filter
                        viewModel.applyFilter()
                    }
                }
            }
        }
    }

    // MARK: - Routines List

    private var routinesList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.filteredRoutines) { routine in
                    RoutineRow(
                        routine: routine,
                        onComplete: {
                            withAnimation {
                                if routine.isCompleted {
                                    viewModel.resetRoutine(routine)
                                } else {
                                    viewModel.completeRoutine(routine)
                                }
                            }
                        },
                        onSkip: {
                            withAnimation {
                                viewModel.skipRoutine(routine)
                            }
                        }
                    )
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.deleteRoutine(routine)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }

                        Button {
                            viewModel.resetRoutine(routine)
                        } label: {
                            Label("Sıfırla", systemImage: "arrow.counterclockwise")
                        }
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Stat Badge

    private func statBadge(icon: String, count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            Text("\(count)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            Text(label)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Spacer()
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: "list.clipboard")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accent.opacity(0.5))

            Text("Henüz Rutin Yok")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textPrimary)

            Text("İlk rutininizi ekleyerek başlayın")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)

            PrimaryButton("Rutin Ekle", icon: "plus") {
                print("Add routine tapped")
            }
            .padding(.horizontal, AppSpacing.xl)

            Spacer()
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let filter: DailyRoutineViewModel.RoutineFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: filter.icon)
                    .font(.caption)

                Text(filter.rawValue)
                    .font(AppFonts.subheadline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? AppColors.accent : AppColors.secondaryBackground)
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    DailyRoutineView()
        .modelContainer(for: [Pet.self, DailyRoutine.self], inMemory: true)
}

//
//  HomeView.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [Pet]
    @State private var selectedPet: Pet?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Pet Selector
                    if !pets.isEmpty {
                        petSelectorSection
                    }

                    // Today's Summary
                    if let pet = selectedPet {
                        todaySummarySection(for: pet)

                        // Quick Actions
                        quickActionsSection

                        // Upcoming Events
                        upcomingEventsSection(for: pet)
                    } else {
                        emptyStateView
                    }

                    Spacer(minLength: AppSpacing.xl)
                }
                .padding(AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle("PetCare+")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add pet action
                        print("Add pet tapped")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
        }
        .onAppear {
            if selectedPet == nil, let firstPet = pets.first {
                selectedPet = firstPet
            }
        }
    }

    // MARK: - Pet Selector Section

    private var petSelectorSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Evcil Hayvanlarım")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(pets) { pet in
                        PetProfileCard(
                            pet: pet,
                            isSelected: selectedPet?.id == pet.id
                        ) {
                            selectedPet = pet
                        }
                        .frame(width: 300)
                    }
                }
            }
        }
    }

    // MARK: - Today's Summary Section

    private func todaySummarySection(for pet: Pet) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Bugünün Özeti")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: AppSpacing.md
            ) {
                StatCard(
                    icon: "list.clipboard.fill",
                    title: "Rutinler",
                    value: "\(pet.todayCompletedRoutinesCount)/\(pet.todayTotalRoutinesCount)",
                    subtitle: String(format: "%.0f%% tamamlandı", pet.todayRoutineProgress * 100),
                    color: AppColors.success
                )

                StatCard(
                    icon: "scalemass.fill",
                    title: "Kilo",
                    value: "\(String(format: "%.1f", pet.weight)) kg",
                    subtitle: "Son ölçüm",
                    color: AppColors.info
                )

                if !pet.exercises.isEmpty, let lastExercise = pet.exercises.last {
                    StatCard(
                        icon: "figure.walk",
                        title: "Son Egzersiz",
                        value: lastExercise.distanceString,
                        subtitle: lastExercise.startTimeString,
                        color: AppColors.accent
                    )
                } else {
                    StatCard(
                        icon: "figure.walk",
                        title: "Egzersiz",
                        value: "0 km",
                        subtitle: "Bugün yok",
                        color: AppColors.gray3
                    )
                }

                if let nextAppointment = pet.healthRecords.first(where: { $0.nextAppointment != nil }) {
                    StatCard(
                        icon: "calendar",
                        title: "Sonraki Randevu",
                        value: daysUntil(nextAppointment.nextAppointment!),
                        subtitle: nextAppointment.type.rawValue,
                        color: AppColors.warning
                    )
                } else {
                    StatCard(
                        icon: "cross.case.fill",
                        title: "Sağlık",
                        value: "\(pet.healthRecords.count)",
                        subtitle: "Kayıt",
                        color: AppColors.error
                    )
                }
            }
        }
    }

    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Hızlı İşlemler")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: AppSpacing.md
            ) {
                quickActionButton(icon: "fork.knife", title: "Besle", color: AppColors.accent)
                quickActionButton(icon: "figure.walk", title: "Egzersiz", color: AppColors.success)
                quickActionButton(icon: "calendar.badge.plus", title: "Randevu", color: AppColors.info)
                quickActionButton(icon: "pills.fill", title: "İlaç", color: AppColors.error)
                quickActionButton(icon: "bubble.left.and.bubble.right.fill", title: "AI Chat", color: AppColors.warning)
                quickActionButton(icon: "camera.fill", title: "Fotoğraf", color: .purple)
            }
        }
    }

    // MARK: - Upcoming Events Section

    private func upcomingEventsSection(for pet: Pet) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Yaklaşan Etkinlikler")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            if let upcomingRoutine = pet.routines.first(where: { !$0.isCompleted && $0.scheduledTime > Date() }) {
                upcomingEventCard(
                    icon: upcomingRoutine.type.icon,
                    title: upcomingRoutine.title,
                    time: upcomingRoutine.scheduledTimeString,
                    color: Color(uiColor: UIColor(named: upcomingRoutine.type.color) ?? .systemOrange)
                )
            }

            if let upcomingHealth = pet.healthRecords.first(where: { $0.isNextAppointmentSoon }) {
                upcomingEventCard(
                    icon: upcomingHealth.type.icon,
                    title: upcomingHealth.title,
                    time: upcomingHealth.nextAppointmentString ?? "",
                    color: Color(uiColor: UIColor(named: upcomingHealth.type.color) ?? .systemRed)
                )
            }

            if pet.routines.allSatisfy({ $0.isCompleted }) && !pet.healthRecords.contains(where: { $0.isNextAppointmentSoon }) {
                emptyEventsView
            }
        }
    }

    // MARK: - Quick Action Button

    private func quickActionButton(icon: String, title: String, color: Color) -> some View {
        Button {
            print("\(title) tapped")
        } label: {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }

                Text(title)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Upcoming Event Card

    private func upcomingEventCard(icon: String, title: String, time: String, color: Color) -> some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textPrimary)

                Text(time)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
    }

    // MARK: - Empty States

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: "pawprint.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accent.opacity(0.5))

            Text("Henüz Evcil Hayvan Eklenmedi")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textPrimary)

            Text("İlk evcil hayvanınızı ekleyerek başlayın")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)

            PrimaryButton("Evcil Hayvan Ekle", icon: "plus") {
                print("Add pet tapped")
            }
            .padding(.horizontal, AppSpacing.xl)

            Spacer()
        }
    }

    private var emptyEventsView: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .foregroundColor(AppColors.success)

            Text("Tüm işler tamamlandı! 🎉")
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.lg)
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
    }

    // MARK: - Helper Methods

    private func daysUntil(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days == 0 {
            return "Bugün"
        } else if days == 1 {
            return "Yarın"
        } else {
            return "\(days) gün"
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .modelContainer(for: [Pet.self, DailyRoutine.self, HealthRecord.self, Exercise.self], inMemory: true)
}

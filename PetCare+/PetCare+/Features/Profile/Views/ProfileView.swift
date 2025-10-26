//
//  ProfileView.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ProfileViewModel
    @State private var showingSettings = false
    @State private var showingAddPet = false

    init() {
        let container = try! ModelContainer(for: Pet.self)
        let context = container.mainContext
        _viewModel = StateObject(wrappedValue: ProfileViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection

                    // Quick Stats
                    quickStatsSection

                    // Pets Section
                    petsSection

                    // Actions
                    actionsSection

                    // About
                    aboutSection
                }
                .padding()
            }
            .navigationTitle("Profil")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAddPet) {
                AddPetSheet(viewModel: viewModel, isPresented: $showingAddPet)
            }
        }
        .onAppear {
            viewModel.loadPets()
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.2))
                    .frame(width: 100, height: 100)

                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(AppColors.accent)
            }

            Text("PetCare+ Kullanıcısı")
                .font(.title3)
                .fontWeight(.semibold)

            Text("\(viewModel.pets.count) Evcil Hayvan")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    // MARK: - Quick Stats Section

    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            ProfileStatCard(
                icon: "pawprint.fill",
                title: "Aktif Pet",
                value: "\(viewModel.pets.filter { $0.isActive }.count)",
                color: .blue
            )

            ProfileStatCard(
                icon: "calendar.badge.clock",
                title: "Yaklaşan",
                value: "\(getTotalUpcomingAppointments())",
                color: .orange
            )

            ProfileStatCard(
                icon: "checkmark.circle.fill",
                title: "Bu Ay",
                value: "\(getThisMonthExercises())",
                color: .green
            )
        }
    }

    // MARK: - Pets Section

    private var petsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Evcil Hayvanlarım")
                    .font(.headline)
                Spacer()
                Button {
                    showingAddPet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppColors.accent)
                }
            }

            if viewModel.pets.isEmpty {
                ContentUnavailableView(
                    "Henüz Pet Eklenmedi",
                    systemImage: "pawprint",
                    description: Text("İlk evcil hayvanınızı ekleyerek başlayın")
                )
                .frame(height: 200)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.pets) { pet in
                        PetManagementRow(
                            pet: pet,
                            onEdit: {
                                viewModel.selectedPet = pet
                            },
                            onDelete: {
                                viewModel.deletePet(pet)
                            }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(spacing: 12) {
            NavigationLink {
                SettingsView(viewModel: viewModel)
            } label: {
                ActionRow(icon: "gearshape.fill", title: "Ayarlar", color: .blue)
            }

            ActionRow(icon: "bell.fill", title: "Bildirimler", color: .orange) {
                showingSettings = true
            }

            ActionRow(icon: "questionmark.circle.fill", title: "Yardım & Destek", color: .green) {
                // Help action
            }

            ActionRow(icon: "info.circle.fill", title: "Hakkında", color: .purple) {
                // About action
            }
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(spacing: 8) {
            Text("PetCare+")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Versiyon 1.0.0")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("© 2025 PetCare+")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.top)
    }

    // MARK: - Helper Methods

    private func getTotalUpcomingAppointments() -> Int {
        viewModel.pets.reduce(0) { total, pet in
            total + pet.appointments.filter { $0.status == .upcoming && !$0.isPast }.count
        }
    }

    private func getThisMonthExercises() -> Int {
        let calendar = Calendar.current
        let now = Date()
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart) else {
            return 0
        }

        return viewModel.pets.reduce(0) { total, pet in
            total + pet.exercises.filter { $0.startDate >= monthStart && $0.startDate < monthEnd }.count
        }
    }
}

// MARK: - ProfileStatCard Component

struct ProfileStatCard: View {
    let icon: String
    let title: String
    let value: String
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

// MARK: - PetManagementRow Component

struct PetManagementRow: View {
    let pet: Pet
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(pet.species.icon)
                .font(.title)

            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.headline)

                Text("\(pet.species.rawValue) • \(pet.ageString)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if !pet.isActive {
                Text("Pasif")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.gray)
                    .clipShape(Capsule())
            }

            Menu {
                Button {
                    onEdit()
                } label: {
                    Label("Düzenle", systemImage: "pencil")
                }

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Sil", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - ActionRow Component

struct ActionRow: View {
    let icon: String
    let title: String
    let color: Color
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 30)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - AddPetSheet

struct AddPetSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var species: PetSpecies = .dog
    @State private var breed: String = ""
    @State private var gender: PetGender = .unknown
    @State private var birthDate: Date = Date()
    @State private var weight: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Temel Bilgiler") {
                    TextField("İsim", text: $name)

                    Picker("Tür", selection: $species) {
                        ForEach(PetSpecies.allCases, id: \.self) { species in
                            HStack {
                                Text(species.icon)
                                Text(species.rawValue)
                            }
                            .tag(species)
                        }
                    }

                    TextField("Cins", text: $breed)

                    Picker("Cinsiyet", selection: $gender) {
                        ForEach([PetGender.male, .female, .unknown], id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }

                Section("Detaylar") {
                    DatePicker("Doğum Tarihi", selection: $birthDate, in: ...Date(), displayedComponents: .date)

                    TextField("Kilo (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }

                Section("Notlar") {
                    TextField("Notlar (Opsiyonel)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Yeni Evcil Hayvan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Ekle") {
                        addPet()
                        dismiss()
                    }
                    .disabled(name.isEmpty || weight.isEmpty)
                }
            }
        }
    }

    private func addPet() {
        let weightValue = Double(weight.replacingOccurrences(of: ",", with: ".")) ?? 0

        viewModel.addPet(
            name: name,
            species: species,
            breed: breed,
            gender: gender,
            birthDate: birthDate,
            weight: weightValue,
            notes: notes
        )
    }
}

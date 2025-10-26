//
//  AppointmentView.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI
import SwiftData

struct AppointmentView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedPet: Pet?
    @StateObject private var viewModel: AppointmentViewModel

    @State private var showingAddAppointment = false

    init(selectedPet: Binding<Pet?>, modelContext: ModelContext) {
        self._selectedPet = selectedPet
        _viewModel = StateObject(wrappedValue: AppointmentViewModel(context: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if selectedPet != nil {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Next Appointment Card
                            if let nextAppointment = viewModel.nextAppointment {
                                nextAppointmentSection(nextAppointment)
                            }

                            // Quick Stats
                            quickStatsSection

                            // Filters
                            filterSection

                            // Appointments List
                            appointmentsListSection
                        }
                        .padding()
                    }
                } else {
                    ContentUnavailableView(
                        "Evcil Hayvan Seçilmedi",
                        systemImage: "pawprint.fill",
                        description: Text("Randevu takibi için bir evcil hayvan seçin")
                    )
                }
            }
            .navigationTitle("Randevular")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedPet != nil {
                        Button {
                            showingAddAppointment = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddAppointment) {
                if let pet = selectedPet {
                    AddAppointmentSheet(
                        viewModel: viewModel,
                        pet: pet,
                        isPresented: $showingAddAppointment
                    )
                }
            }
        }
        .onChange(of: selectedPet) { oldValue, newValue in
            if let pet = newValue {
                viewModel.loadAppointments(for: pet)
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
                viewModel.loadAppointments(for: pet)
            }
        }
    }

    // MARK: - Next Appointment Section

    private func nextAppointmentSection(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sıradaki Randevu")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Image(systemName: appointment.type.icon)
                    .font(.title)
                    .foregroundStyle(appointment.type.swiftUIColor)
                    .frame(width: 60, height: 60)
                    .background(appointment.type.swiftUIColor.opacity(0.1))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.title)
                        .font(.headline)

                    Text(appointment.dateString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if !appointment.location.isEmpty {
                        Text(appointment.location)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text(appointment.timeUntil)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(appointment.type.swiftUIColor)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        appointment.type.swiftUIColor.opacity(0.1),
                        appointment.type.swiftUIColor.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Quick Stats Section

    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            AppointmentStatCard(
                title: "Bugün",
                value: "\(viewModel.todayAppointments.count)",
                icon: "calendar.badge.clock",
                color: .orange
            )

            AppointmentStatCard(
                title: "Bu Hafta",
                value: "\(viewModel.thisWeekAppointments.count)",
                icon: "calendar",
                color: .blue
            )

            AppointmentStatCard(
                title: "Yaklaşan",
                value: "\(viewModel.upcomingAppointments.count)",
                icon: "clock",
                color: .green
            )
        }
    }

    // MARK: - Filter Section

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AppointmentViewModel.AppointmentFilter.allCases, id: \.self) { filter in
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

    // MARK: - Appointments List Section

    private var appointmentsListSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Tüm Randevular")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.filteredAppointments.count) randevu")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.filteredAppointments.isEmpty {
                ContentUnavailableView(
                    "Randevu Yok",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Henüz randevu bulunmuyor")
                )
                .frame(height: 200)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredAppointments) { appointment in
                        AppointmentCard(
                            appointment: appointment,
                            onComplete: {
                                viewModel.completeAppointment(appointment)
                            },
                            onCancel: {
                                viewModel.cancelAppointment(appointment)
                            },
                            onDelete: {
                                viewModel.deleteAppointment(appointment)
                            }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - AppointmentStatCard Component

struct AppointmentStatCard: View {
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

// MARK: - AddAppointmentSheet

struct AddAppointmentSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AppointmentViewModel
    let pet: Pet
    @Binding var isPresented: Bool

    @State private var type: AppointmentType = .veterinary
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var duration: Int = 30
    @State private var location: String = ""
    @State private var veterinarianName: String = ""
    @State private var notes: String = ""
    @State private var reminderMinutesBefore: Int = 60
    @State private var cost: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Randevu Bilgileri") {
                    Picker("Tip", selection: $type) {
                        ForEach(AppointmentType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }

                    TextField("Başlık (Opsiyonel)", text: $title)

                    DatePicker("Tarih ve Saat", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])

                    Picker("Süre", selection: $duration) {
                        Text("15 dakika").tag(15)
                        Text("30 dakika").tag(30)
                        Text("45 dakika").tag(45)
                        Text("1 saat").tag(60)
                        Text("1.5 saat").tag(90)
                        Text("2 saat").tag(120)
                    }
                }

                Section("Lokasyon") {
                    TextField("Klinik/Yer", text: $location)
                    TextField("Veteriner Adı", text: $veterinarianName)
                }

                Section("Ek Bilgiler") {
                    TextField("Maliyet (₺)", text: $cost)
                        .keyboardType(.decimalPad)

                    Picker("Hatırlatma", selection: $reminderMinutesBefore) {
                        Text("15 dakika önce").tag(15)
                        Text("30 dakika önce").tag(30)
                        Text("1 saat önce").tag(60)
                        Text("2 saat önce").tag(120)
                        Text("1 gün önce").tag(1440)
                    }

                    TextField("Notlar", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Yeni Randevu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Ekle") {
                        addAppointment()
                        dismiss()
                    }
                }
            }
        }
    }

    private func addAppointment() {
        let costValue = Double(cost.replacingOccurrences(of: ",", with: ".")) ?? 0

        viewModel.addAppointment(
            type: type,
            title: title.isEmpty ? nil : title,
            date: date,
            duration: duration,
            location: location,
            veterinarianName: veterinarianName,
            notes: notes,
            reminderMinutesBefore: reminderMinutesBefore,
            cost: costValue
        )
    }
}

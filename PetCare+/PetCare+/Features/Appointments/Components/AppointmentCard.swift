//
//  AppointmentCard.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI

struct AppointmentCard: View {
    let appointment: Appointment
    let onComplete: () -> Void
    let onCancel: () -> Void
    let onDelete: () -> Void

    @State private var showingEditSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Icon
                Image(systemName: appointment.type.icon)
                    .font(.title2)
                    .foregroundStyle(appointment.type.swiftUIColor)
                    .frame(width: 44, height: 44)
                    .background(appointment.type.swiftUIColor.opacity(0.1))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.title)
                        .font(.headline)

                    HStack(spacing: 4) {
                        Image(systemName: appointment.status.icon)
                            .font(.caption2)
                        Text(appointment.status.rawValue)
                            .font(.caption)
                    }
                    .foregroundStyle(appointment.status.swiftUIColor)
                }

                Spacer()

                // Menu
                Menu {
                    if appointment.status == .upcoming && !appointment.isPast {
                        Button {
                            onComplete()
                        } label: {
                            Label("Tamamlandı", systemImage: "checkmark.circle")
                        }

                        Button {
                            onCancel()
                        } label: {
                            Label("İptal Et", systemImage: "xmark.circle")
                        }

                        Divider()
                    }

                    Button {
                        showingEditSheet = true
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
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }

            // Date & Time
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(appointment.dateOnlyString)
                        .font(.subheadline)
                }

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(appointment.timeString)
                        .font(.subheadline)
                }

                if appointment.status == .upcoming && !appointment.isPast {
                    Spacer()
                    Text(appointment.timeUntil)
                        .font(.caption)
                        .foregroundStyle(appointment.type.swiftUIColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(appointment.type.swiftUIColor.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            // Details
            VStack(alignment: .leading, spacing: 8) {
                if !appointment.location.isEmpty {
                    DetailRow(icon: "mappin.circle.fill", text: appointment.location)
                }

                if !appointment.veterinarianName.isEmpty {
                    DetailRow(icon: "person.circle.fill", text: appointment.veterinarianName)
                }

                DetailRow(icon: "clock.fill", text: appointment.durationString)

                if appointment.cost > 0 {
                    DetailRow(icon: "banknote", text: appointment.costString)
                }
            }

            // Notes
            if !appointment.notes.isEmpty {
                Text(appointment.notes)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .sheet(isPresented: $showingEditSheet) {
            EditAppointmentSheet(appointment: appointment)
        }
    }
}

// MARK: - DetailRow Component

struct DetailRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 16)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - EditAppointmentSheet

struct EditAppointmentSheet: View {
    @Environment(\.dismiss) private var dismiss
    let appointment: Appointment

    @State private var type: AppointmentType
    @State private var title: String
    @State private var date: Date
    @State private var duration: Int
    @State private var location: String
    @State private var veterinarianName: String
    @State private var notes: String
    @State private var reminderMinutesBefore: Int
    @State private var cost: String

    init(appointment: Appointment) {
        self.appointment = appointment
        _type = State(initialValue: appointment.type)
        _title = State(initialValue: appointment.title)
        _date = State(initialValue: appointment.date)
        _duration = State(initialValue: appointment.duration)
        _location = State(initialValue: appointment.location)
        _veterinarianName = State(initialValue: appointment.veterinarianName)
        _notes = State(initialValue: appointment.notes)
        _reminderMinutesBefore = State(initialValue: appointment.reminderMinutesBefore)
        _cost = State(initialValue: appointment.cost > 0 ? String(format: "%.2f", appointment.cost) : "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Randevu Bilgileri") {
                    Picker("Tip", selection: $type) {
                        ForEach(AppointmentType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }

                    TextField("Başlık", text: $title)

                    DatePicker("Tarih ve Saat", selection: $date, displayedComponents: [.date, .hourAndMinute])

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
            .navigationTitle("Randevuyu Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveChanges() {
        let costValue = Double(cost.replacingOccurrences(of: ",", with: ".")) ?? 0

        appointment.type = type
        appointment.title = title
        appointment.date = date
        appointment.duration = duration
        appointment.location = location
        appointment.veterinarianName = veterinarianName
        appointment.notes = notes
        appointment.reminderMinutesBefore = reminderMinutesBefore
        appointment.cost = costValue
    }
}

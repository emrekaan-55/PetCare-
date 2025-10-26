//
//  ExerciseCard.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let onDelete: () -> Void

    @State private var showingEditSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: exercise.type.icon)
                    .font(.title2)
                    .foregroundStyle(exercise.type.color)
                    .frame(width: 40, height: 40)
                    .background(exercise.type.color.opacity(0.1))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.type.rawValue)
                        .font(.headline)

                    Text(formatDate(exercise.date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Menu {
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

            // Stats
            HStack(spacing: 16) {
                StatItem(
                    icon: "clock.fill",
                    value: formatDuration(exercise.duration),
                    label: "Süre"
                )

                if let distance = exercise.distance, distance > 0 {
                    Divider()
                        .frame(height: 30)

                    StatItem(
                        icon: "location.fill",
                        value: String(format: "%.2f km", distance),
                        label: "Mesafe"
                    )
                }

                if let notes = exercise.notes, !notes.isEmpty {
                    Divider()
                        .frame(height: 30)

                    StatItem(
                        icon: "note.text",
                        value: "✓",
                        label: "Not"
                    )
                }
            }

            // Notes
            if let notes = exercise.notes, !notes.isEmpty {
                Text(notes)
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
            EditExerciseSheet(exercise: exercise)
        }
    }

    // MARK: - Helper Methods

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return "Bugün, \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "HH:mm"
            return "Dün, \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "dd MMM, HH:mm"
            return formatter.string(from: date)
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

// MARK: - StatItem Component

struct StatItem: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.primary)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - EditExerciseSheet

struct EditExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: Exercise

    @State private var distance: String
    @State private var notes: String

    init(exercise: Exercise) {
        self.exercise = exercise
        _distance = State(initialValue: exercise.distance != nil ? String(format: "%.2f", exercise.distance!) : "")
        _notes = State(initialValue: exercise.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Egzersiz Bilgileri") {
                    HStack {
                        Text("Tip")
                        Spacer()
                        Text(exercise.type.rawValue)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Tarih")
                        Spacer()
                        Text(formatDate(exercise.date))
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Süre")
                        Spacer()
                        Text(formatDuration(exercise.duration))
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Ek Bilgiler") {
                    TextField("Mesafe (km)", text: $distance)
                        .keyboardType(.decimalPad)

                    TextField("Notlar", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Egzersizi Düzenle")
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
        let distanceValue = Double(distance.replacingOccurrences(of: ",", with: "."))
        exercise.distance = distanceValue
        exercise.notes = notes.isEmpty ? nil : notes
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.string(from: date)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d saat %d dakika", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%d dakika %d saniye", minutes, seconds)
        } else {
            return String(format: "%d saniye", seconds)
        }
    }
}

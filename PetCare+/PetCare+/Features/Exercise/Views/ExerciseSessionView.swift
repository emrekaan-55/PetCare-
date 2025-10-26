//
//  ExerciseSessionView.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI

struct ExerciseSessionView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var distance: String = ""
    @State private var notes: String = ""
    @State private var showingStopConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        viewModel.activeExercise?.type.swiftUIColor.opacity(0.3) ?? .blue.opacity(0.3),
                        viewModel.activeExercise?.type.swiftUIColor.opacity(0.1) ?? .blue.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // Exercise Type
                    VStack(spacing: 12) {
                        Image(systemName: viewModel.activeExercise?.type.icon ?? "figure.run")
                            .font(.system(size: 60))
                            .foregroundStyle(viewModel.activeExercise?.type.swiftUIColor ?? .blue)

                        Text(viewModel.activeExercise?.title ?? "Egzersiz")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }

                    // Timer
                    VStack(spacing: 8) {
                        Text(formatElapsedTime())
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .monospacedDigit()

                        Text(viewModel.isPaused ? "DURAKLATILDI" : "AKTİF")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(viewModel.isPaused ? .orange : .green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                (viewModel.isPaused ? Color.orange : Color.green).opacity(0.2)
                            )
                            .clipShape(Capsule())
                    }

                    // Stats
                    HStack(spacing: 40) {
                        StatColumn(
                            icon: "flame.fill",
                            value: "\(Int(viewModel.elapsedTime / 60))",
                            unit: "kal",
                            color: .red
                        )

                        StatColumn(
                            icon: "figure.walk",
                            value: formatPace(),
                            unit: "tempo",
                            color: .blue
                        )

                        StatColumn(
                            icon: "location.fill",
                            value: distance.isEmpty ? "0.0" : distance,
                            unit: "km",
                            color: .green
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground).opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Spacer()

                    // Controls
                    VStack(spacing: 20) {
                        // Pause/Resume Button
                        Button {
                            if viewModel.isPaused {
                                viewModel.resumeExercise()
                            } else {
                                viewModel.pauseExercise()
                            }
                        } label: {
                            HStack {
                                Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                Text(viewModel.isPaused ? "Devam Et" : "Duraklat")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.activeExercise?.type.swiftUIColor ?? .blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        // Stop and Cancel Buttons
                        HStack(spacing: 12) {
                            Button {
                                showingStopConfirmation = true
                            } label: {
                                HStack {
                                    Image(systemName: "stop.fill")
                                    Text("Bitir")
                                }
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }

                            Button {
                                viewModel.cancelExercise()
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "xmark")
                                    Text("İptal")
                                }
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingStopConfirmation) {
                StopExerciseSheet(
                    distance: $distance,
                    notes: $notes,
                    onStop: {
                        let distanceValue = Double(distance.replacingOccurrences(of: ",", with: "."))
                        viewModel.stopExercise(
                            distance: distanceValue,
                            notes: notes.isEmpty ? nil : notes
                        )
                        dismiss()
                    }
                )
            }
        }
    }

    // MARK: - Helper Methods

    private func formatElapsedTime() -> String {
        let hours = Int(viewModel.elapsedTime) / 3600
        let minutes = (Int(viewModel.elapsedTime) % 3600) / 60
        let seconds = Int(viewModel.elapsedTime) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    private func formatPace() -> String {
        guard let distanceValue = Double(distance.replacingOccurrences(of: ",", with: ".")),
              distanceValue > 0,
              viewModel.elapsedTime > 0 else {
            return "0:00"
        }

        let paceMinutes = viewModel.elapsedTime / 60 / distanceValue
        let minutes = Int(paceMinutes)
        let seconds = Int((paceMinutes - Double(minutes)) * 60)

        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - StatColumn Component

struct StatColumn: View {
    let icon: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()

            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - StopExerciseSheet

struct StopExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var distance: String
    @Binding var notes: String
    let onStop: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Egzersiz Detayları") {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.blue)
                        TextField("Mesafe (km)", text: $distance)
                            .keyboardType(.decimalPad)
                    }

                    HStack(alignment: .top) {
                        Image(systemName: "note.text")
                            .foregroundStyle(.orange)
                            .padding(.top, 8)
                        TextField("Notlar (opsiyonel)", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }

                Section {
                    Button {
                        onStop()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Egzersizi Bitir")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Egzersiz Tamamlandı")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

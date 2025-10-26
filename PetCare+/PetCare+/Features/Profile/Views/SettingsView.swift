//
//  SettingsView.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            Form {
                // Appearance Section
                Section("Görünüm") {
                    Picker("Tema", selection: $viewModel.selectedTheme) {
                        ForEach(ProfileViewModel.AppTheme.allCases, id: \.self) { theme in
                            HStack {
                                Image(systemName: theme.icon)
                                Text(theme.rawValue)
                            }
                            .tag(theme)
                        }
                    }
                    .onChange(of: viewModel.selectedTheme) { oldValue, newValue in
                        viewModel.changeTheme(newValue)
                    }
                }

                // Notifications Section
                Section("Bildirimler") {
                    Toggle("Bildirimleri Aç", isOn: $viewModel.notificationsEnabled)
                        .onChange(of: viewModel.notificationsEnabled) { oldValue, newValue in
                            viewModel.saveSettings()
                        }

                    if viewModel.notificationsEnabled {
                        DatePicker(
                            "Günlük Hatırlatma",
                            selection: $viewModel.dailyReminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: viewModel.dailyReminderTime) { oldValue, newValue in
                            viewModel.updateDailyReminder(newValue)
                        }
                    }
                }

                // Data Section
                Section("Veri Yönetimi") {
                    Button {
                        // Export data
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.blue)
                            Text("Verileri Dışa Aktar")
                                .foregroundStyle(.primary)
                        }
                    }

                    Button {
                        // Import data
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundStyle(.green)
                            Text("Verileri İçe Aktar")
                                .foregroundStyle(.primary)
                        }
                    }

                    Button(role: .destructive) {
                        // Clear all data
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Tüm Verileri Sil")
                        }
                    }
                }

                // About Section
                Section("Hakkında") {
                    HStack {
                        Text("Versiyon")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Geliştirici")
                        Spacer()
                        Text("PetCare+ Team")
                            .foregroundStyle(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Image(systemName: "link")
                            Text("GitHub")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }

                    Link(destination: URL(string: "https://twitter.com")!) {
                        HStack {
                            Image(systemName: "link")
                            Text("Twitter")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                }

                // Support Section
                Section("Destek") {
                    Button {
                        // Rate app
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text("Uygulamayı Değerlendir")
                                .foregroundStyle(.primary)
                        }
                    }

                    Button {
                        // Send feedback
                    } label: {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.blue)
                            Text("Geri Bildirim Gönder")
                                .foregroundStyle(.primary)
                        }
                    }

                    Button {
                        // Report bug
                    } label: {
                        HStack {
                            Image(systemName: "ladybug.fill")
                                .foregroundStyle(.red)
                            Text("Hata Bildir")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Tamam") {
                        dismiss()
                    }
                }
            }
        }
    }
}

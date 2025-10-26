//
//  MainTabView.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    // MARK: - Properties

    @State private var selectedTab: Tab = .home

    // MARK: - Tab Enum

    enum Tab {
        case home
        case routine
        case exercise
        case chat
        case calendar
        case profile
    }

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
                .tag(Tab.home)

            // Daily Routine Tab
            DailyRoutineView()
                .tabItem {
                    Label("Rutinler", systemImage: "list.clipboard.fill")
                }
                .tag(Tab.routine)

            // Exercise Tab
            ExerciseTabView()
                .tabItem {
                    Label("Egzersiz", systemImage: "figure.run")
                }
                .tag(Tab.exercise)

            // AI Chat Tab
            PetChatView()
                .tabItem {
                    Label("AI Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(Tab.chat)

            // Calendar Tab
            CalendarView()
                .tabItem {
                    Label("Takvim", systemImage: "calendar")
                }
                .tag(Tab.calendar)

            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(AppColors.accent) // Tab bar tint color
    }
}

// MARK: - Placeholder Views (Geçici)

struct ExerciseTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [Pet]
    @State private var selectedPet: Pet?

    var body: some View {
        ExerciseView(selectedPet: $selectedPet, modelContext: modelContext)
            .onAppear {
                if selectedPet == nil, let firstPet = pets.first {
                    selectedPet = firstPet
                }
            }
    }
}

struct PetChatView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    Text("🤖 AI Chat")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.accent)

                    Text("Burası AI chat ekranı olacak.\nEvcil hayvanın davranışlarını açıkla, AI analiz etsin.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Pet AI Chat")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CalendarView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    Text("📅 Takvim")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.accent)

                    Text("Burası takvim ekranı olacak.\nVeteriner randevuları, aşı takvimleri, hatırlatıcılar.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Takvim")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    Text("👤 Profil")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.accent)

                    Text("Burası profil ekranı olacak.\nKullanıcı bilgileri, petler, ayarlar.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Profil & Ayarlar")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}

#Preview("Dark Mode") {
    MainTabView()
        .preferredColorScheme(.dark)
}

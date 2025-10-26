//
//  ContentView.swift
//  PetCare+
//
//  Created by Emre Kaan on 25.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Header
                    headerSection

                    // Welcome Message
                    welcomeCard

                    // Features Preview
                    featuresSection

                    // Button Examples
                    buttonsSection

                    Spacer(minLength: AppSpacing.xl)
                }
                .padding(AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle("PetCare+")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent)

            Text("PetCare+")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.textPrimary)

            Text("Evcil Hayvan Bakım Asistanı")
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.xl)
    }

    // MARK: - Welcome Card

    private var welcomeCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppColors.success)
                    .font(AppFonts.title2)

                Text("Kurulum Tamamlandı!")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
            }

            Text("PetCare+ projesi başarıyla kuruldu. Proje yapısı hazır, temel component'ler oluşturuldu.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()
                .padding(.vertical, AppSpacing.sm)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                checklistItem("✅ Klasör yapısı oluşturuldu")
                checklistItem("✅ AppColors, AppFonts, AppSpacing hazır")
                checklistItem("✅ View Extensions eklendi")
                checklistItem("✅ PrimaryButton & SecondaryButton oluşturuldu")
                checklistItem("🚀 UI tasarımına başlamaya hazır!")
            }
        }
        .cardStyle()
    }

    // MARK: - Features Section

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Ana Özellikler")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                featureCard(icon: "list.clipboard.fill", title: "Günlük Rutin", color: AppColors.info)
                featureCard(icon: "figure.walk", title: "Egzersiz Takip", color: AppColors.success)
                featureCard(icon: "bubble.left.and.bubble.right.fill", title: "AI Chat", color: AppColors.accent)
                featureCard(icon: "camera.fill", title: "Görsel Tanıma", color: AppColors.warning)
                featureCard(icon: "calendar", title: "Takvim", color: AppColors.error)
                featureCard(icon: "cross.case.fill", title: "Sağlık Kimliği", color: .purple)
            }
        }
    }

    // MARK: - Buttons Section

    private var buttonsSection: some View {
        VStack(spacing: AppSpacing.md) {
            Text("Component Örnekleri")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            PrimaryButton("Başlayalım", icon: "arrow.right") {
                print("🚀 Proje başladı!")
            }

            SecondaryButton("Dokümantasyonu Gör", icon: "doc.text") {
                print("📚 README.md açılıyor")
            }

            HStack(spacing: AppSpacing.md) {
                PrimaryButton("Kaydet", icon: "checkmark.circle") {
                    print("💾 Kaydedildi")
                }

                SecondaryButton("İptal") {
                    print("❌ İptal")
                }
            }
        }
    }

    // MARK: - Helper Views

    private func checklistItem(_ text: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Text(text)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
        }
    }

    private func featureCard(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)

            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}

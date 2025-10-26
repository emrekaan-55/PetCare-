//
//  StatCard.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

struct StatCard: View {
    // MARK: - Properties

    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    let color: Color
    let action: (() -> Void)?

    // MARK: - Initialization

    init(
        icon: String,
        title: String,
        value: String,
        subtitle: String? = nil,
        color: Color = AppColors.accent,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    cardContent
                }
                .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
    }

    // MARK: - Card Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }

            Spacer()

            // Value
            Text(value)
                .font(AppFonts.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)

            // Title
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)

            // Subtitle
            if let subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(AppColors.textSecondary.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .cornerRadius(16)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: AppSpacing.md) {
            StatCard(
                icon: "checkmark.circle.fill",
                title: "Tamamlanan",
                value: "4/8",
                subtitle: "Bugünkü rutinler",
                color: AppColors.success
            )

            StatCard(
                icon: "flame.fill",
                title: "Yakılan Kalori",
                value: "250",
                subtitle: "kcal",
                color: AppColors.accent
            )
        }

        HStack(spacing: AppSpacing.md) {
            StatCard(
                icon: "figure.walk",
                title: "Mesafe",
                value: "2.5 km",
                subtitle: "Bugün",
                color: AppColors.info
            ) {
                print("Mesafe tapped")
            }

            StatCard(
                icon: "calendar",
                title: "Sonraki",
                value: "2 gün",
                subtitle: "Veteriner",
                color: AppColors.warning
            )
        }
    }
    .padding()
}

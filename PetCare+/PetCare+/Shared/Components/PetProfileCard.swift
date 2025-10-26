//
//  PetProfileCard.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

struct PetProfileCard: View {
    // MARK: - Properties

    let pet: Pet
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Header
                HStack {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(AppColors.accent.opacity(0.1))
                            .frame(width: 50, height: 50)

                        Text(pet.species.icon)
                            .font(.system(size: 28))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(pet.name)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)

                        Text("\(pet.breed) • \(pet.ageString)")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.accent)
                            .font(.title3)
                    }
                }

                // Stats
                HStack(spacing: AppSpacing.md) {
                    statItem(icon: "scalemass.fill", value: "\(String(format: "%.1f", pet.weight)) kg", label: "Kilo")

                    Divider()
                        .frame(height: 30)

                    statItem(icon: "heart.fill", value: "\(pet.age) yıl", label: "Yaş")

                    Divider()
                        .frame(height: 30)

                    statItem(
                        icon: "checkmark.circle.fill",
                        value: String(format: "%.0f%%", pet.todayRoutineProgress * 100),
                        label: "Rutin"
                    )
                }
                .padding(.top, AppSpacing.sm)
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.accent.opacity(0.1) : AppColors.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? AppColors.accent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Stat Item

    private func statItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(AppColors.accent)

            Text(value)
                .font(AppFonts.caption)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)

            Text(label)
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        PetProfileCard(pet: Pet.sample, isSelected: true) {
            print("Karamel selected")
        }

        PetProfileCard(pet: Pet.samples[1], isSelected: false) {
            print("Max selected")
        }
    }
    .padding()
}

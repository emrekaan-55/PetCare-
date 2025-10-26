//
//  SecondaryButton.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

struct SecondaryButton: View {
    // MARK: - Properties

    let title: String
    let icon: String?
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(AppFonts.headline)
                }
                Text(title)
                    .font(AppFonts.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.secondaryBackground)
            .foregroundColor(isEnabled ? AppColors.accent : AppColors.gray3)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isEnabled ? AppColors.accent : AppColors.gray3, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        SecondaryButton("İptal") {
            print("İptal")
        }

        SecondaryButton("Geri", icon: "arrow.left") {
            print("Geri")
        }

        SecondaryButton("Devre Dışı") {
            print("Tıklanamaz")
        }
        .disabled(true)
    }
    .padding()
}

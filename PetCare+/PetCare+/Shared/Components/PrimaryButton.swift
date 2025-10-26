//
//  PrimaryButton.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

struct PrimaryButton: View {
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
            .background(isEnabled ? AppColors.accent : AppColors.gray3)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Default") {
    VStack(spacing: 20) {
        PrimaryButton("Kaydet") {
            print("Kaydedildi")
        }

        PrimaryButton("Devam Et", icon: "arrow.right") {
            print("Devam edildi")
        }

        PrimaryButton("Devre Dışı") {
            print("Tıklanamaz")
        }
        .disabled(true)
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        PrimaryButton("Kaydet", icon: "checkmark.circle") {
            print("Kaydedildi")
        }

        PrimaryButton("İptal") {
            print("İptal")
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}

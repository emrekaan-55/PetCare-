//
//  FilterChip.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? AppColors.accent : AppColors.secondaryBackground)
            .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
            .clipShape(Capsule())
        }
    }
}

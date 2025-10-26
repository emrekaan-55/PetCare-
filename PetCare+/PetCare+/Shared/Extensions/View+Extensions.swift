//
//  View+Extensions.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

extension View {
    // MARK: - Glass Morphism Effect

    /// Glass morphism efekti uygular (iOS modern tasarım)
    func glassEffect() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
    }

    // MARK: - Card Style

    /// Modern kart görünümü uygular
    func cardStyle(padding: CGFloat = AppSpacing.md) -> some View {
        self
            .padding(padding)
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Section Card Style

    /// Section için özelleştirilmiş kart stili
    func sectionCardStyle() -> some View {
        self
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.background)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
            )
    }
}

// MARK: - Conditional Modifiers

extension View {
    /// Koşullu modifier uygulamak için helper
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

//
//  AppColors.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

struct AppColors {
    // MARK: - VURGU RENGİ - TURUNCU (Ana kimlik rengi)
    static let accent = Color.orange
    static let accentLight = Color.orange.opacity(0.7)
    static let accentDark = Color(red: 1.0, green: 0.55, blue: 0.0) // #FF8C00

    // MARK: - ARKA PLAN RENKLERİ - Glass Morphism
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)

    // MARK: - GLASS EFEKTİ
    static let glassBackground = Color.white.opacity(0.7)
    static let glassBorder = Color.white.opacity(0.3)

    // MARK: - GRİ TONLARI
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let gray1 = Color(.systemGray)
    static let gray2 = Color(.systemGray2)
    static let gray3 = Color(.systemGray3)
    static let gray4 = Color(.systemGray4)
    static let gray5 = Color(.systemGray5)
    static let gray6 = Color(.systemGray6)

    // MARK: - SEMANTIC COLORS
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    static let info = Color.blue
}

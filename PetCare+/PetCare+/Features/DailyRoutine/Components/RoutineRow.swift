//
//  RoutineRow.swift
//  PetCare+
//
//  Created on 25.10.2025.
//

import SwiftUI

struct RoutineRow: View {
    // MARK: - Properties

    let routine: DailyRoutine
    let onComplete: () -> Void
    let onSkip: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Checkbox
            Button(action: onComplete) {
                ZStack {
                    Circle()
                        .stroke(
                            routine.isCompleted ? AppColors.success : AppColors.gray3,
                            lineWidth: 2
                        )
                        .frame(width: 28, height: 28)

                    if routine.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundColor(AppColors.success)
                    }
                }
            }
            .buttonStyle(.plain)

            // Type Icon
            ZStack {
                Circle()
                    .fill(typeColor.opacity(0.1))
                    .frame(width: 40, height: 40)

                Image(systemName: routine.type.icon)
                    .foregroundColor(typeColor)
                    .font(.callout)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(routine.title)
                    .font(AppFonts.subheadline)
                    .foregroundColor(routine.isCompleted ? AppColors.textSecondary : AppColors.textPrimary)
                    .strikethrough(routine.isCompleted)

                HStack(spacing: AppSpacing.sm) {
                    // Time
                    Label(routine.scheduledTimeString, systemImage: "clock")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)

                    // Duration
                    if routine.duration > 0 {
                        Text("•")
                            .foregroundColor(AppColors.textSecondary)

                        Text("\(routine.duration) dk")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    // Status Badge
                    if routine.isLate && !routine.isCompleted {
                        Text("•")
                            .foregroundColor(AppColors.textSecondary)

                        Text("Geç")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppColors.error)
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()

            // Skip Button
            if !routine.isCompleted {
                Button(action: onSkip) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.gray3)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(routine.isCompleted ? AppColors.gray6.opacity(0.3) : AppColors.secondaryBackground)
        )
    }

    // MARK: - Type Color

    private var typeColor: Color {
        switch routine.type {
        case .feeding:
            return AppColors.accent
        case .water:
            return AppColors.info
        case .bathroom:
            return .brown
        case .exercise:
            return AppColors.success
        case .medication:
            return AppColors.error
        case .grooming:
            return .purple
        case .playtime:
            return .pink
        case .training:
            return .indigo
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        RoutineRow(routine: DailyRoutine.samples[0], onComplete: {}, onSkip: {})
        RoutineRow(routine: DailyRoutine.samples[1], onComplete: {}, onSkip: {})
        RoutineRow(routine: DailyRoutine.samples[2], onComplete: {}, onSkip: {})
    }
    .padding()
}

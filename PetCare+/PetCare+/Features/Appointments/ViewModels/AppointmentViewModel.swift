//
//  AppointmentViewModel.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
class AppointmentViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var appointments: [Appointment] = []
    @Published var filteredAppointments: [Appointment] = []
    @Published var selectedFilter: AppointmentFilter = .upcoming
    @Published var isLoading = false
    @Published var searchText = ""

    // MARK: - Filter Enum

    enum AppointmentFilter: String, CaseIterable {
        case all = "Tümü"
        case upcoming = "Yaklaşan"
        case today = "Bugün"
        case thisWeek = "Bu Hafta"
        case completed = "Tamamlanan"

        var icon: String {
            switch self {
            case .all: return "list.bullet"
            case .upcoming: return "clock"
            case .today: return "calendar.badge.clock"
            case .thisWeek: return "calendar"
            case .completed: return "checkmark.circle.fill"
            }
        }
    }

    // MARK: - Properties

    private let context: ModelContext
    private var currentPet: Pet?

    // MARK: - Computed Properties

    var upcomingAppointments: [Appointment] {
        appointments
            .filter { $0.status == .upcoming && !$0.isPast }
            .sorted { $0.date < $1.date }
    }

    var todayAppointments: [Appointment] {
        appointments.filter { $0.isToday && $0.status == .upcoming }
    }

    var thisWeekAppointments: [Appointment] {
        appointments.filter { $0.isThisWeek && $0.status == .upcoming }
    }

    var completedAppointments: [Appointment] {
        appointments
            .filter { $0.status == .completed }
            .sorted { $0.date > $1.date }
    }

    var nextAppointment: Appointment? {
        upcomingAppointments.first
    }

    // MARK: - Initialization

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Methods

    /// Randevuları yükle
    func loadAppointments(for pet: Pet) {
        isLoading = true
        currentPet = pet

        // Geçmiş randevuların durumlarını güncelle
        pet.appointments.forEach { $0.updateStatusIfNeeded() }

        appointments = pet.appointments.sorted { $0.date > $1.date }
        applyFilter()
        isLoading = false
    }

    /// Filter uygula
    func applyFilter() {
        var filtered = appointments

        // Filter type'a göre
        switch selectedFilter {
        case .all:
            break
        case .upcoming:
            filtered = filtered.filter { $0.status == .upcoming && !$0.isPast }
        case .today:
            filtered = filtered.filter { $0.isToday && $0.status == .upcoming }
        case .thisWeek:
            filtered = filtered.filter { $0.isThisWeek && $0.status == .upcoming }
        case .completed:
            filtered = filtered.filter { $0.status == .completed }
        }

        // Search text'e göre
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText) ||
                $0.veterinarianName.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Yaklaşan randevular tarih sırasına göre (eskiden yeniye)
        // Tamamlanan randevular tarih sırasına göre (yeniden eskiye)
        if selectedFilter == .upcoming || selectedFilter == .today || selectedFilter == .thisWeek {
            filtered.sort { $0.date < $1.date }
        } else {
            filtered.sort { $0.date > $1.date }
        }

        filteredAppointments = filtered
    }

    /// Yeni randevu ekle
    func addAppointment(
        type: AppointmentType,
        title: String?,
        date: Date,
        duration: Int,
        location: String,
        veterinarianName: String,
        notes: String,
        reminderMinutesBefore: Int,
        cost: Double
    ) {
        guard let currentPet else { return }

        let appointment = Appointment(
            type: type,
            title: title ?? "",
            date: date,
            duration: duration,
            location: location,
            veterinarianName: veterinarianName,
            notes: notes,
            reminderMinutesBefore: reminderMinutesBefore,
            cost: cost,
            pet: currentPet
        )

        context.insert(appointment)
        saveContext()
        loadAppointments(for: currentPet)
    }

    /// Randevuyu güncelle
    func updateAppointment(
        _ appointment: Appointment,
        type: AppointmentType,
        title: String,
        date: Date,
        duration: Int,
        location: String,
        veterinarianName: String,
        notes: String,
        reminderMinutesBefore: Int,
        cost: Double
    ) {
        appointment.type = type
        appointment.title = title
        appointment.date = date
        appointment.duration = duration
        appointment.location = location
        appointment.veterinarianName = veterinarianName
        appointment.notes = notes
        appointment.reminderMinutesBefore = reminderMinutesBefore
        appointment.cost = cost

        saveContext()
        applyFilter()
    }

    /// Randevuyu tamamla
    func completeAppointment(_ appointment: Appointment) {
        appointment.complete()
        saveContext()
        applyFilter()
    }

    /// Randevuyu iptal et
    func cancelAppointment(_ appointment: Appointment) {
        appointment.cancel()
        saveContext()
        applyFilter()
    }

    /// Randevuyu sil
    func deleteAppointment(_ appointment: Appointment) {
        context.delete(appointment)
        saveContext()
        if let currentPet {
            loadAppointments(for: currentPet)
        }
    }

    // MARK: - Private Methods

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

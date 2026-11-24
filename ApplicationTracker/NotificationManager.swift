//
//  NotificationManager.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 19/11/26.
//

import Foundation
import UserNotifications

struct NotificationManager {
    func requestPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
    }
    func cancelReminder(id: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func scheduleReminder(for application: Application) async throws {
        guard application.reminder,
              let interviewDate = application.interviewDate else {
            return
        }

        let reminderDate = interviewDate.addingTimeInterval(-30 * 60)

        guard reminderDate > .now else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Interview"
        content.body = "Your interview for \(application.jobTitle) at \(application.companyName) starts in 30 minutes."
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminderDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: application.reminderID,
            content: content,
            trigger: trigger
        )

        try await UNUserNotificationCenter.current().add(request)
    }
}

//
//  NotificationManager.swift
//  My project
//
//  Created by Mohamad Hleihel on 2023-12-08.
//

import Foundation
import UserNotifications


class NotificationManager {
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Authorization granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleNotification(title: String, body: String, hour: [Int]) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default

                for hourValue in hour {
                    var dateComponents = DateComponents()
                    dateComponents.hour = hourValue
                    dateComponents.minute = 0

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    center.add(request)
                }
            }
        }
    }
}


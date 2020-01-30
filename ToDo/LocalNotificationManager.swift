//
//  LocalNotificationManager.swift
//  ToDo
//
//  Created by John Gallaugher on 1/30/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager
{
    struct LocalNotification {
        var id: String
        var title: String
        var dateComponents: DateComponents
    }
    
    var notifications = [LocalNotification]()
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if granted == true && error == nil {
                print("Local Notification Permission Granted")
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    func listScheduledNotifications() {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            print("!- There are currently \(notifications.count) notifications scheduled")
            for (index, notification) in notifications.enumerated() {
                print("\(index). \(notification.content.title) \(notification.identifier)")
            }
        }
    }
    
    private func scheduleNotifications() {
        for notification in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}

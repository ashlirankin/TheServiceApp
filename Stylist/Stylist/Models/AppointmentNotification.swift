//
//  AppointmentNotification.swift
//  Stylist
//
//  Created by Oniel Rosario on 5/1/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import UserNotifications


class AppointmentNotification {
    let authservice = AuthService()
    var statusListener: ListenerRegistration!
    private init(){
        guard let currentUser = authservice.getCurrentUser() else {
            return
        }
        DBService.getBookedAppointments(userId: currentUser.uid) { (error, appointments) in
            if let error = error {
                print(error)
            } else if let appointments = appointments {
                self.appointments = appointments
            }
        }
    }
    
    
    static let shared = AppointmentNotification()
    var appointments = [Appointments]() {
        didSet {
                        notifyClient()
        }
    }
    
    func notifyClient() {
            for status in AppointmentStatus.allCases {
                statusListener = DBService.firestoreDB.collection("bookedAppointments")
                    .whereField("status", isEqualTo: status.rawValue)
                    .addSnapshotListener({ (snapshot, error) in
                        if let error = error {
                            print(error)
                        } else if snapshot != nil {
                            self.setupNotification()
                        }
                    })
            }
        }
    
    private func setupNotification() {
            guard let newAppointment = appointments.last else {
                return
            }
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "New Appointment"
            content.subtitle = "\(newAppointment.appointmentTime)"
            content.sound = UNNotificationSound.default
            content.threadIdentifier = "local-notifcations temp"
            let date = Date(timeIntervalSinceNow: 5)
            let dateComponent = Calendar.current.dateComponents([.year, .month,.day,.hour, .minute, .second, .second, .nanosecond], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest.init(identifier: "content", content: content, trigger: trigger)
            center.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
}




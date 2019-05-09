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

protocol AppointmentNotificationDelegate: AnyObject {
    func appointmentUpdate(status: String, appointment: Appointments, provider: ServiceSideUser)
}

class AppointmentNotification {
    weak var delegate: AppointmentNotificationDelegate?
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
                guard appointments.count > 0 else  {
                    return
                }
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
        guard let currentUser = self.authservice.getCurrentUser() else {
            return
        }
        for status in AppointmentStatus.allCases {
            statusListener = DBService.firestoreDB.collection("bookedAppointments")
                .whereField("status", isEqualTo: status.rawValue)
                .whereField("userId", isEqualTo: currentUser.uid)
                .addSnapshotListener({ (snapshot, error) in
                    if let error = error {
                        print(error)
                    } else if let snapshot = snapshot {
                        guard snapshot.documents.count > 0 else  {
                            return
                        }
                        let latestAppoinment = snapshot.documents.map{ Appointments(dict: $0.data())}.last!
                        DBService.getProviderFromAppointment(appointment: latestAppoinment, completion: { (error, provider) in
                            if let error = error {
                                print(error)
                            } else if let provider = provider {
                                self.delegate?.appointmentUpdate(status: status.rawValue, appointment: latestAppoinment, provider: provider)
                            }
                        })
                        
                        
                    }
                })
        }
    }
    
    private func setupNotification(status: AppointmentStatus) {
        switch status {
        case .pending:
            guard let newAppointment = appointments.first else {
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
        case .inProgress:
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Your Appointment has been confirmed"
            content.subtitle = "your provider is on the way"
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
        case .canceled:
            guard let newAppointment = appointments.last else {
                return
            }
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Your Appointment has been canceled"
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
        case .completed:
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Appointment Completed"
            content.subtitle = "please rate your service!"
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
}





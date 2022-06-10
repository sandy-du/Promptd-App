//
//  NotificationsViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 10/6/2022.
//  References: https://www.youtube.com/watch?v=qDbbdvTYpVI&ab_channel=CodeWithCal
//  https://www.hackingwithswift.com/read/21/2/scheduling-notifications-unusernotificationcenter-and-unnotificationrequest
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    let notifcationCenter = UNUserNotificationCenter.current()
    let titleNotif = "Promptd - Reminder"
    let bodyNotif = "Don't forget to write and flex your creative muscle today!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationAuthorisation()
    }
    
    func requestNotificationAuthorisation(){
        notifcationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if (!permissionGranted) {
                print("Permission Denied")
            }
            
        }
    }

    @IBAction func scheduleNotification(_ sender: Any) {
        let time = datePicker.date
        notifcationCenter.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async {
                if (settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = self.titleNotif
                    content.body = self.bodyNotif
                    
                    let dateComp = Calendar.current.dateComponents([.hour, .minute], from: time)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notifcationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error: \(error.debugDescription)")
                            return
                        }
                        
                    }
                    self.goToHomePage()
                } else {
                    let ac = UIAlertController(title: "Notifications not enabled", message: "Please enable notifications in settings to set reminders", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if (UIApplication.shared.canOpenURL(settingsURL)) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    @IBAction func declineSchedule(_ sender: Any) {
        goToHomePage()
    }
    
    func formatTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    func goToHomePage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreen = storyboard.instantiateViewController(withIdentifier: "homeScreen") as! HomeTabBarController
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(homeScreen)
    }
}

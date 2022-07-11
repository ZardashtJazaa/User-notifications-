//
//  UnService.swift
//  Reminder
//
//  Created by Zardasht  on 09/07/2022.
//

import Foundation
import UserNotifications

class UnService: NSObject {
    
    static let shared = UnService()
    private override init() {}
    
    private let unCenter = UNUserNotificationCenter.current()
    //MARK: Authorizations
    func authorize() {
        
        let options : UNAuthorizationOptions = [.alert , .badge , .carPlay , .sound]
        unCenter.requestAuthorization(options: options) { granted, error in
            
            if error != nil {
                print("Error Authorizations!!")
            }
            guard granted else {
                print("USER DENIDE ACCESS")
                return
            }
          
            self.configure()
        }

    }
    
    //MARK: SetupActions && Categories
    func setUpActionsAndCategories() {
        
        //Actions
        let timerActions = UNNotificationAction(identifier: notificationsActionID.timer.rawValue,
                                                title: "Run Timer",
                                                options: [.authenticationRequired])
        
        let dateActions = UNNotificationAction(identifier: notificationsActionID.date.rawValue,
                                               title: "Run Date",
                                               options: [.destructive])
        
        let locationAction = UNNotificationAction(identifier: notificationsActionID.location.rawValue,
                                                  title: "Run Location",
                                                  options: [.foreground])
        
        // Cateogry
        let timerCateogry = UNNotificationCategory(identifier: notificationCategoryID.timer.rawValue,
                                                   actions: [timerActions],
                                                   intentIdentifiers: [])
        
        let dateCategory = UNNotificationCategory(identifier: notificationCategoryID.date.rawValue,
                                                  actions: [dateActions],
                                                  intentIdentifiers: [])
        
        let locationCategory = UNNotificationCategory(identifier: notificationCategoryID.location.rawValue,
                                                      actions: [locationAction],
                                                      intentIdentifiers: [])
        //we have all the actions added to Cateogory and all the category added to the UserNotificationsCenter!!..
        unCenter.setNotificationCategories([timerCateogry,dateCategory,locationCategory])
        
        
    }
    
    
    private func configure() {
        self.unCenter.delegate = self
        setUpActionsAndCategories()
    }
    
    //MARK: Attachments
    
    func getAttachment(for id: AttachmentNotificationsID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
            
        case .timer: imageName = "TimeAlert"
            
        case .date: imageName = "DateAlert"
            
        case.location: imageName = "LocationAlert"
            
        }
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        
        do {
            
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url, options: nil)
            return attachment
        }
        catch {
            return nil
        }
    }
    
    
    //MARK: TimerRequest
    func timerRequest(with interval: TimeInterval) {
        
        let content = UNMutableNotificationContent()
        content.title = "Time is Up!"
        content.badge = 1
        content.body = "Your all Time is Done!!"
        content.sound = .default
        content.categoryIdentifier = notificationCategoryID.timer.rawValue
        
        if let timerAttachment = getAttachment(for: .timer) {
            
            content.attachments =  [timerAttachment]
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false) // if the time is more than 60s
        let request = UNNotificationRequest(identifier: "UserNotifications.Timer", content: content, trigger: trigger)
        unCenter.add(request)
        
    }
    //MARK: DateRequest
    
    func dateRequest(with dateComponent: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date Time!"
        content.body = "This is the Date now!"
        content.badge = 1
        content.sound = .default
        content.categoryIdentifier = notificationCategoryID.date.rawValue
        
        if let dateAttachment = getAttachment(for: .date) {
            content.attachments =  [dateAttachment]
        }
        
        let triger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request =  UNNotificationRequest(identifier: "UserNotificatons.Date",
                                             content: content,
                                             trigger: triger)
        unCenter.add(request)
        
    }
    //MARK: LocationsRequest
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "You have Returned"
        content.body = "Welcome back Friend :)"
        content.badge = 1
        content.sound = .default
        content.categoryIdentifier = notificationCategoryID.location.rawValue
        
        if let locationAttachment = getAttachment(for: .location) {
            
            content.attachments = [locationAttachment]
        }
        
        print("LocationRequest!")
        let request = UNNotificationRequest(identifier: "userNotifications.locations",
                                            content: content,
                                            trigger: nil)
        unCenter.add(request)
        
    }
    

}
//MARK: Extentions
extension UnService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("You Did Recive Response!!")
        
        if let action = notificationsActionID(rawValue: response.actionIdentifier) {
            
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"), object: action)
            
        }
            
        completionHandler()
    }
    
}

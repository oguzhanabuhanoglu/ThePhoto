//
//  NotificationsManager.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import Foundation

final class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    enum type : Int {
        case like = 1
        case comment = 2
        case friendRequest = 3
    }
    
    public func getNotifications(completion: @escaping ([TPNotification]) -> Void){
        DatabaseManager.shared.getNotifications(completion: completion)
    }
    
    public func create(notification: TPNotification, for username: String) {
        let id = notification.identifier
        guard let dictionary = notification.asDictionary() else {
            return
        }
        DatabaseManager.shared.insertNotification(identifier: id, data: dictionary, for: username)
    }
    
    static func newIdentifier() -> String{
        let date = Date()
        let number = Int.random(in: 1...1000)
        let number2 = Int.random(in: 1...1000)
        return "\(number)_\(number2)_\(date.timeIntervalSince1970)"
    }
    
}

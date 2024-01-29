//
//  Notification.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 27.01.2024.
//

import Foundation

public struct TPNotification: Codable{
    //all 
    let identifier: String
    let notificationType: Int //1:like 2:comment 3:friends
    let profilePicture: String
    let username: String
    let dateString: String
    //like/comment
    let postId: String?
    let postUrl: String?
    
}

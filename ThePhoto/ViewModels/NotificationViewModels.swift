//
//  NotificationViewModels.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import Foundation

struct FriendRequestCellViewModel {
    let username: String
    let profilePictureUrl: URL
    
}

struct LikeCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
}

struct CommentCellViewModel {
    let username: String
    let profilePicturUrl: URL
    let postUrl: URL
}

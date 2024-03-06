//
//  NotificationViewModels.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import Foundation

struct FriendRequestCellViewModel: Equatable {
    let username: String
    let profilePictureUrl: URL
    let date: String
    //isFollowing to iaFriends
    
}

struct LikeCellViewModel: Equatable{
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
}

struct CommentCellViewModel: Equatable{
    let username: String
    let profilePicturUrl: URL
    let postUrl: URL
    let date: String
}

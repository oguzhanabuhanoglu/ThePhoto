//
//  NotificationCellType.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import Foundation

enum NotificationCellTypes {
case firendRequest(viewModel: FriendRequestCellViewModel)
case like(viewModel: LikeCellViewModel)
case comment(viewModel: CommentCellViewModel)
}

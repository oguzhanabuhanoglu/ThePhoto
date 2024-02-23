//
//  ProfileHeaderViewModel.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 2.02.2024.
//

import Foundation

enum profileButtonType {
    case edit
    case addFriend(isFriend: Bool)
}
                   
public struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let name: String?
    let bio: String?
    let challangeScore: Int
    let dailyImage: URL?
    let buttonType: profileButtonType
}

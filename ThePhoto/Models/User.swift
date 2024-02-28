//
//  User.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import Foundation

public struct User : Codable{
    let username: String
    let email: String
}

public struct UserInfo: Codable {
    let username: String 
    let name: String
    let bio: String?
    let score: Int?
}

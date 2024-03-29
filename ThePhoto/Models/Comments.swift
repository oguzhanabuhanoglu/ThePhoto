//
//  Comments.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 28.03.2024.
//

import Foundation

public struct Comments: Codable{
    let profilePicture: URL?
    let username: String
    let commment: String
    let dateString: String
}

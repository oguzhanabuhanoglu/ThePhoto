//
//  Post.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 12.01.2024.
//

import Foundation

public struct Post : Codable {
    let id: String
    let caption: String
    let postedDate: String
    var likers: [String]
}

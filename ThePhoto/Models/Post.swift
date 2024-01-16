//
//  Post.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 12.01.2024.
//

import Foundation
import FirebaseFirestore

public struct Post : Codable {
    let id: String
    let postUrl: String
    let caption: String
    var postedDate: String
    var likers: [String]
    
    //to get post data from storage
    var storageReference : String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        return "\(username)/posts/\(id).png"
    }
}

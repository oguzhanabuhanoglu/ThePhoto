//
//  userSingleton.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 25.02.2024.
//

import Foundation
import UIKit

class userSingleton {
    
    static let sharedInstance = userSingleton()
    
    var profileImage = UIImage()
    var name = String()
    var username = String()
    var bio = String()
    var score = Int()
    
    
    private init(){}
    
}

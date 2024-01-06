//
//  StorageManager.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    let storage = Storage.storage().reference()
    
    public enum storageErrorManager: Error {
        case failedToDownload
    }
    
    /*public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void) {
        
    }*/
    
    public func uploadProfilePicture(username: String, data: Data?, completion: @escaping (Bool) -> Void){
        guard let data = data else {
            return
        }
        storage.child("\(username)/profile_picture_png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
 
    
}

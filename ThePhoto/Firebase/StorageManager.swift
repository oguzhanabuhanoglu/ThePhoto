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

    //uploda profile picture which i get when user sign up
    public func uploadProfilePicture(username: String, data: Data?, completion: @escaping (Bool) -> Void){
        guard let data = data else {
            return
        }
        storage.child("\(username)/profile_picture_png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    
    
    public func uploadPost(data: Data?, id: String, completion: @escaping (URL?) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username"), let data = data else {
            return
        }
        let ref = storage.child("\(username)/posts/\(id).png")
        ref.putData(data) { _, error in
            //get post image data from storage for post model
            ref.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    public func downloadPosrURL(for post: Post, completion: @escaping (URL?) -> Void) {
        guard let ref = post.storageReference else {
            return
        }
        storage.child(ref).downloadURL { url, _ in
            completion(url)
        }
    }
    

    //get profile picture url
    public func profilePictureURL(for username: String, completion: @escaping (URL?) -> Void){
        storage.child("\(username)/profile_picture_png").downloadURL { url, _ in
            completion(url)
        }
        
    }
    
    
    
    
 
    
}

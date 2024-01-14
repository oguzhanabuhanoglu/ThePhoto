//
//  DatabaseManager.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import FirebaseFirestore

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let database = Firestore.firestore()
    
    //check username and email for availability
    public func canCreateAccount(username: String, email: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    
    public func getPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void){
        let ref = database.collection("users").document(username).collection("posts")
        
        ref.getDocuments { snapshot, error in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }), error == nil else {
                
                return
            }
            
            completion(.success(posts))
        }
    }
    
    
    public func createPost(newPost: Post, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
             completion(false)
             return
        }
        let reference = database.document("users/\(username)/posts/\(newPost.id)")
        guard let data = newPost.asDictionary() else{
            completion(false)
            return
        }
        reference.setData(data) { error in
            completion(error == nil)
        }
    }
    
    
    
    public func createNewUser(newUser :User, completion: @escaping (Bool) -> Void) {
        let reference = database.document("users/\(newUser.username)")
        guard let data = newUser.asDictionary() else{
            completion(false)
            return
        }
        reference.setData(data) { error in
            completion(error == nil)
        }
    }

    public func findUser(with email: String, completion: @escaping (User?) -> Void){
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with:$0.data()) }), error == nil else {
                completion(nil)
                return
            }
            let user = users.first(where:{ $0.email == email})
            completion(user)
        }
    }

}




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
    
    // MARK: User Info
    
    public func getUserInfo(username: String, completion: @escaping (UserInfo?) -> Void) {
        let ref = database.collection("users").document(username).collection("information").document("basic")
        ref.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let userInfo = UserInfo(with: data) else {
                completion(nil)
                return
            }
            completion(userInfo)
        }
    }
    
    public func setUserInfo(userInfo: UserInfo, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username"),
            let data = userInfo.asDictionary() else {
                return
            }
        let ref = database.collection("users").document(username).collection("information").document("basic")
        ref.setData(data) { error in
            completion(error == nil)
        }
    }
    

    // MARK: User - Search
    
    //check username and email for availability
    public func canCreateAccount(username: String, email: String, completion: (Bool) -> Void) {
        completion(true)
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
    
    public func searchByUsername(with usernamePrefix: String, completion: @escaping ([User]) -> Void){
        let ref = database.collection("users")
        
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                return
            }
            let subset = users.filter({ $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())})
            completion(subset)
        }
    }
    
    
    
    // MARK: Post
    
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

    //problem here
    public func getPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void){
        let ref = database.collection("users").document(username).collection("posts")

        ref.order(by: "postedDate", descending: true).getDocuments { snapshot, error in
            guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else {
                return
            }
            completion(.success(posts))
        }
    }
    
    //get particular post for notifications
    public func getNotificatedPost(with identifier: String, from username: String, completion: @escaping (Post?) -> Void){
        let ref = database.collection("users").document(username).collection("posts").document(identifier)
        ref.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            completion(Post(with: data))
        }
        
    }
    
    
    
    // MARK: Notifications
    
    public func getNotifications(completion: @escaping ([TPNotification]) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let ref = database.collection("users").document(username).collection("notifications")
        ref.getDocuments { snapshot, error in
            guard let notifications = snapshot?.documents.compactMap({ TPNotification(with: $0.data())})
                    , error == nil else {
                completion([])
                return
            }
            completion(notifications)
        }
    }
    
    
    public func insertNotification(identifier: String, data: [String:Any], for username: String) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let ref = database.collection("users").document(username).collection("notifications").document(identifier)
        ref.setData(data)
    }
   
   
    // MARK: Relaationships
    
    public enum RelationshipState{
        case addFriend
        case removeFriend
    }
    
    public func updateRelationship(state: RelationshipState, for targetUsername: String, completion: @escaping (Bool) -> Void){
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let currentUserFriends = database.collection("users").document(currentUsername).collection("friendList")
        let targetUserFriends = database.collection("users").document(targetUsername).collection("friendList")
        
        switch state {
        case .addFriend:
            // push notifitaciton to the target user and its gonna be friendRequest notification
            
            //that code just for testing
            currentUserFriends.addDocument(data: ["valid" : "1"])
            targetUserFriends.addDocument(data: ["valid" : "1"])
            break
        case .removeFriend:
            // remove targetUser from currentUser friendList on database
            currentUserFriends.document(targetUsername).delete()
            // remove currentUser from targetUser friendList on database
            targetUserFriends.document(currentUsername).delete()
        }
    }
    
    public func isFollowing(targetUsername: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let ref = database.collection("users").document(targetUsername).collection("friendList").document(currentUsername)
        
        ref.getDocument { snapshot, error in
            guard snapshot?.data() != nil, error == nil else {
                //not following
                completion(false)
                return
            }
            //following
            completion(true)
        }
    }
    
}











/* ref.getDocuments { snapshot, error in
     guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else {
         return
     }
     completion(.success(posts))
 }*/
/*public func getPosts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
    let ref = database.collection("users").document(username).collection("posts").order(by: "postedDate", descending: true).addSnapshotListener { snapshot, error in
        guard error == nil, snapshot?.isEmpty == false else {
            // Hata durumunu işle veya return yap
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(error!)) // Hata türünü belirtin
            }
            return
        }

        // compactMap'ı sadece bir kere çağır
        if var posts = snapshot?.documents.compactMap({ Post(with: $0.data()) }) {
            completion(.success(posts))
        } else {
            // compactMap başarısız olduğunda işlemi hata olarak işle
            completion(.failure(error!)) // Hata türünü belirtin
        }
    }
}*/

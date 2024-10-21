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
    
    public func findUserWUsername(with username: String, completion: @escaping (User?) -> Void){
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data())}), error == nil else {
                completion(nil)
                return
            }
            let user = users.first(where: {$0.username == username})
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
    
    static var secretProfile = false
    
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

        ref.getDocuments { snapshot, error in
            guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data()) }).sorted(by: { return $0.date! > $1.date! }) , error == nil else {
                return
            }
            completion(.success(posts))
        }
    }
    

    //get particular post
    public func getPost(with identifier: String, from username: String, completion: @escaping (Post?) -> Void){
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
       /* guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }*/
        let ref = database.collection("users").document(username).collection("notifications").document(identifier)
        ref.setData(data)
    }
    

    public func deleteNotificationsFromMe(targetUsername: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        let ref = database.collection("users").document(username).collection("notifications")
        ref.document("\(targetUsername)_3").delete { error in
            if let error = error {
                print("Error deleting notification: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    public func deleteNotificationsFromTarget(targetUsername: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let ref = database.collection("users").document(targetUsername).collection("notifications") 
        ref.document("\(username)_3").delete()
    }
    
    
    // MARK: Relaationships
    
    static var isFriend = false
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
            
            currentUserFriends.document(targetUsername).setData(["valid" : "1"])
            targetUserFriends.document(currentUsername).setData(["valid" : "1"])

            completion(true)
        case .removeFriend:
            // remove targetUser from currentUser friendList on database
            currentUserFriends.document(targetUsername).delete()
            // remove currentUser from targetUser friendList on database
            targetUserFriends.document(currentUsername).delete()
            completion(true)
        }
    }
    
    public func friendRequest(state: RelationshipState, for targetUsername: String, completion: @escaping (Bool) -> Void){
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let currentUserFriends = database.collection("users").document(currentUsername).collection("friendRequestList")
        let targetUserFriends = database.collection("users").document(targetUsername).collection("friendRequestList")
        
        switch state {
        case .addFriend:
            // push notifitaciton to the target user and its gonna be friendRequest notification
            targetUserFriends.document(currentUsername).setData(["valid" : "1"])

            completion(true)
        case .removeFriend:
            // remove targetUser from currentUser friendList on database
            currentUserFriends.document(targetUsername).delete()
            // remove currentUser from targetUser friendList on database
            targetUserFriends.document(currentUsername).delete()
            completion(true)
        }
    }
    
    public func getFriends(for username: String, completion: @escaping ([String]) -> Void){
        let ref = database.collection("users").document(username).collection("friendList")
        ref.getDocuments { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID}) , error == nil else {
                completion([])
                return
            }
            completion(usernames)
        }
    }
    
    public func checkRequestList(targetUsername: String, completion: @escaping (Bool) -> Void) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let ref = database.collection("users").document(targetUsername).collection("friendRequestList").document(currentUsername)
        
        ref.getDocument { snapshot, error in
            guard snapshot?.data() != nil, error == nil else {
                //there isnt request from putecular user
                completion(false)
                return
            }
            //there is request
            completion(true)
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
    
    
    // MARK: Comments
    public func getComments(postID: String, username: String, completion: @escaping ([Comments]) -> Void){
        let ref = database.collection("users").document(username).collection("posts").document(postID).collection("comments")
        ref.getDocuments { snapshot, error in
            guard let comments = snapshot?.documents.compactMap({Comments(with: $0.data())}), error == nil else {
                completion([])
                return
            }
            completion(comments)
        }
    }
    
    public func createComments(comment: Comments, postID: String, username: String, completion: @escaping (Bool) -> Void) {
        let uuid = UUID().uuidString
        let ref = database.collection("users").document(username).collection("posts").document(postID).collection("comments").document(uuid)
        guard let data = comment.asDictionary() else {
            return
        }
        ref.setData(data) { error in
            completion(error == nil)
        }
    }
    
    // MARK: liking
    
    public enum LikeState {
        case like
        case unlike
    }
    
    public func updateLikeState(state: LikeState, postID: String, owner: String, completion: @escaping (Bool) -> Void){
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let ref = database.collection("users").document(owner).collection("posts").document(postID)
        
        getPost(with: postID, from: owner) { post in
            guard var post = post else{
                completion(false)
                return
            }
            
            switch state{
            case .like:
                if !post.likers.contains(currentUsername){
                    post.likers.append(currentUsername)
                }
                
            case.unlike:
                post.likers.removeAll(where: {$0 == currentUsername})
            }
            
            guard let data = post.asDictionary() else{
                completion(false)
                return
            }
            ref.setData(data) { error in
                completion(error == nil)
            }
            
        }
    }
    
    
}













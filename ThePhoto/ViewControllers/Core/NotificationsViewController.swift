//
//  NotificationsViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let noActivityLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No notifications yet"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = true
        table.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: FriendRequestTableViewCell.identifier)
        table.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.identifier)
        table.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        return table
    }()
    
    private var viewModels : [NotificationCellTypes] = []
    
    //to override model which notifications i fetched from database
    private var models: [TPNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noActivityLabel)
    
        tableView.delegate = self
        tableView.dataSource = self

        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
    }
    
    //fonksiyonun çıktısı bir TPNotificationstu bunu alıp burada olusturduğumu modele eşitledik.
    private func fetchNotifications(){
        NotificationsManager.shared.getNotifications { models in
            DispatchQueue.main.async {
                self.models = models
                self.createViewModel()
            }
        }
    }
    
    private func createViewModel(){
        models.forEach { model in
            guard let type = NotificationsManager.type(rawValue: model.notificationType) else {
                return
            }
            
            let username = model.username
            guard let profilePicture = URL(string : model.profilePicture) else {
                return
            }
            
            switch type {
            case .like:
                guard let postUrl = URL(string: model.postUrl ?? "") else {
                    return
                }
                viewModels.append(.like(viewModel: LikeCellViewModel(username: username, profilePictureUrl: profilePicture, postUrl: postUrl, date: model.dateString)))
                
            case .comment:
                guard let postUrl = URL(string: model.postUrl ?? "") else {
                    return
                }
                viewModels.append(.comment(viewModel: CommentCellViewModel(username: username, profilePicturUrl: profilePicture, postUrl: postUrl, date: model.dateString)))
                
            case .friendRequest:
                viewModels.append(.firendRequest(viewModel: FriendRequestCellViewModel(username: username, profilePictureUrl: profilePicture, date: model.dateString, isFriends: false)))
                
            }
        }
        
        if viewModels.isEmpty {
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        }else{
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    /*private func createMockData(){
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png") else {
            return
        }
        
        guard let iconUrl = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else {
            return
        }
        
        viewModels = [
            .like(viewModel: LikeCellViewModel(username: "HakanKa", profilePictureUrl: iconUrl, postUrl: postUrl, date: "21 march")),
            .comment(viewModel: CommentCellViewModel(username: "ybasaran", profilePicturUrl: iconUrl, postUrl: postUrl, date: "21 march")),
            .firendRequest(viewModel: FriendRequestCellViewModel(username: "krcabtu", profilePictureUrl: iconUrl, date: "21 march")),
        ]
        
        tableView.reloadData()
    }*/

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .firendRequest(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestTableViewCell.identifier, for: indexPath) as? FriendRequestTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = viewModels[indexPath.row]
        let username: String
        switch cellType {
        case.like(let viewModel):
            username = viewModel.username
        case.comment(let viewModel):
            username = viewModel.username
        case.firendRequest(let viewModel):
            username = viewModel.username
        }
        
        DatabaseManager.shared.findUserWUsername(with: username) { user in
            if let user = user {
                DispatchQueue.main.async {
                    let vc = ProfileViewController(user: user)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.065
    }


}

//ACTİONS
extension NotificationsViewController: LikeNotificationTableViewCellDelegate, CommentNotificationTableViewCellDelegate, FriendRequestNotificationTableViewCellDelegate {
    

    func FriendRequestNotificationTableViewCell(_ cell: FriendRequestTableViewCell, didTapAcceptButton viewModel: FriendRequestCellViewModel) {
        
        DatabaseManager.shared.friendRequest(state: .removeFriend, for: viewModel.username) { success in
            if !success{
                print("failed when delete request")
            }else{
                DatabaseManager.shared.updateRelationship(state: .addFriend, for: viewModel.username) { completed in
                    if !completed{
                        print("failed when addin friend")
                    }else{
                        DatabaseManager.isFriend = true
                        DatabaseManager.shared.deleteNotificationsFromMe(targetUsername: viewModel.username) { success in
                            if !success {
                                print("issue on delete notification")
                            }else{
                                DispatchQueue.main.async {
                                    if let index = self.models.firstIndex(where: { $0.username == viewModel.username }) {
                                        // İlgili satırın indeksini viewModel dizisinden bul
                                        if let rowIndex = self.viewModels.firstIndex(where: {
                                            if case .firendRequest(let currentViewModel) = $0 {
                                                return currentViewModel.username == viewModel.username
                                            } else {
                                                return false
                                            }
                                        }) {
                                            // İlgili satırı tablodan kaldır
                                            self.viewModels.remove(at: rowIndex)
                                            DispatchQueue.main.async {
                                                // Tabloyu güncelle
                                                self.tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    
 
    func FriendRequestNotificationTableViewCell(_ cell: FriendRequestTableViewCell, didTapDeclineButton viewModel: FriendRequestCellViewModel) {
        DatabaseManager.shared.friendRequest(state: .removeFriend, for: viewModel.username) { success in
            if !success {
                print("issue on delete request")
            }else{
              DatabaseManager.shared.deleteNotificationsFromMe(targetUsername: viewModel.username) { success in
                    if !success {
                        print("issue on delete notification")
                    }else{
                     
                        if let index = self.models.firstIndex(where: { $0.username == viewModel.username }) {
                            // İlgili satırın indeksini viewModel dizisinden bul
                            if let rowIndex = self.viewModels.firstIndex(where: {
                                if case .firendRequest(let currentViewModel) = $0 {
                                    return currentViewModel.username == viewModel.username
                                } else {
                                    return false
                                }
                            }) {
                                // İlgili satırı tablodan kaldır
                                self.viewModels.remove(at: rowIndex)
                                DispatchQueue.main.async {
                                    // Tabloyu güncelle
                                    self.tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell, didTapPostWith viewModel: LikeCellViewModel) {
        //like alan postu açmamız lazım.viewModeldan username alıp databaseden username e göre postu cekmemiz lazım.
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .comment, .firendRequest:
                return false
            case .like(let current):
                return current == viewModel
            }
        })else{
            return
        }
        
        openPost(with: index, username: viewModel.username)
    }
    
    
    func commentNotificationTableViewCell(_ cell: CommentNotificationTableViewCell, didTapPostWith viewModel: CommentCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .like, .firendRequest:
                return false
            case .comment(let current):
                return current == viewModel
            }
        })else {
            return
        }
        
        openPost(with: index, username: viewModel.username)
     
        
    }
    
    func openPost(with index: Int, username: String){
        guard index < models.count else {
            return
        }
        
        let model = models[index]
        let username = username
        guard let postID = model.postId else {
            return
        }
        
        //get post from database to show on post vc with identifier
        DatabaseManager.shared.getPost(with: postID, from: username) { [weak self] post in
            DispatchQueue.main.async {
                guard let post = post else {
                    let alert = UIAlertController(title: "Oops", message: "We are unable to open this post!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                
                let vc = PostViewController(post: post)
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
}

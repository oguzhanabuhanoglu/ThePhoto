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
        table.register(LikeTableViewCell.self, forCellReuseIdentifier: LikeTableViewCell.identifier)
        table.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return table
    }()
    
    private var viewModels : [NotificationCellTypes] = []
    
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeTableViewCell.identifier, for: indexPath) as? LikeTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .firendRequest(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestTableViewCell.identifier, for: indexPath) as? FriendRequestTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    
    private func fetchNotifications(){
        createMockData()
    }
    
    private func createMockData(){
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png") else {
            return
        }
        
        guard let iconUrl = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else {
            return
        }
        
        viewModels = [
            .like(viewModel: LikeCellViewModel(username: "HakanKa", profilePictureUrl: iconUrl, postUrl: postUrl)),
            .comment(viewModel: CommentCellViewModel(username: "ybasaran", profilePicturUrl: iconUrl, postUrl: postUrl)),
            .firendRequest(viewModel: FriendRequestCellViewModel(username: "krcabtu", profilePictureUrl: iconUrl)),
        ]
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.07
    }

   

}

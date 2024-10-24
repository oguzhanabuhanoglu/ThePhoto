//
//  ProfileViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class ProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView?
    
    
    
    private let noActivityLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "You are not friends"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let user: User
    var onGetUser: (() -> User?)?
    private var headerViewModel: ProfileHeaderViewModel?
    private var posts: [Post] = []
    
   
    
    private var isCurrentUser : Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user.username
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        configureCollectionView()
        view.addSubview(noActivityLabel)
        fetchProfileInfo()
        print(user.username)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView?.frame = view.bounds
        noActivityLabel.frame = CGRect(x: 0, y: view.frame.size.height * 0.45, width: view.frame.size.width, height: view.frame.size.height * 0.3)
        
        
        
        
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.2"), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapFriendButton))
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        if isCurrentUser {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapSettingsButton))
            navigationItem.rightBarButtonItem?.tintColor = .label
        }
    }
    
   
    
    @objc func didTapSettingsButton(){
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func didTapFriendButton() {
        let vc = ListViewController(type: .friends(user: user))
        vc.title = "Friends"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func fetchProfileInfo(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        var profilePictureUrl: URL?
        var buttonType: profileButtonType = .edit
        var name: String = ""
        var bio: String? = ""
        var score: Int? = 0
        
        let group = DispatchGroup()
        
        //DATA FOR COLLECTİON POSTS
        
        
        
        group.enter()
        DatabaseManager.shared.isFollowing(targetUsername: user.username) { yes in
            if yes {
                DatabaseManager.shared.getPosts(for: self.user.username) { result in
                    defer {
                        group.leave()
                    }
                    
                    switch result {
                    case .success(let posts):
                        self.posts = posts
                    case .failure:
                        break
                    }
                }
            }else if username == self.user.username{
                DatabaseManager.shared.getPosts(for: self.user.username) { result in
                    defer {
                        group.leave()
                    }
                    
                    switch result {
                    case .success(let posts):
                        self.posts = posts
                    case .failure:
                        break
                    }
                }
            } else {
                DatabaseManager.shared.getPosts(for: self.user.username) { result in
                    defer {
                        group.leave()
                    }
                    
                    switch result {
                    case .success(let posts):
                        self.posts = []
                        self.noActivityLabel.isHidden = false
                    case .failure:
                        break
                    }
                }
                
            }
        }
        
        
        
        //DATA FOR HEADER
        //profile picture url
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            profilePictureUrl = url
        }
        
        //name, bio, challange score
        group.enter()
        DatabaseManager.shared.getUserInfo(username: user.username) { userInfo in
            defer{
                group.leave()
            }
            if let userInfo = userInfo {
                    name = userInfo.name
                    bio = userInfo.bio
                    score = userInfo.score
                } else {
                    name = ""
                    bio = ""
                    score = 0
                }
            print(name)
        }
        
        
        //last image user shared
        

        
        //BUTTON TYPE
        if !isCurrentUser {
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username) { isFollowing in
                defer{
                    group.leave()
                }
                print(isFollowing)
                buttonType = .addFriend(isFriend: isFollowing)
            }
        }
        
        group.notify(queue: .main) {
            self.headerViewModel = ProfileHeaderViewModel(profilePictureUrl: profilePictureUrl,
                                                   name: name,
                                                   bio: bio,
                                                   challangeScore: score ?? 0,
                                                   dailyImage: nil,
                                                   buttonType: buttonType)
            self.collectionView?.reloadData()
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.username = user.username
        if let viewModel = headerViewModel {
            header.configure(with: viewModel)
            header.delegate = self
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let vc = PostViewController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}










extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    
    func profileHeaderReusableViewDidTapEditProfile(_ profileHeader: ProfileHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.completion = {
            // refetch header info
        }
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC ,animated: true)
        
    }
    
    
    
    func profileHeaderReusableViewDidTapAddFriend(_ profileHeader: ProfileHeaderCollectionReusableView) {
        DatabaseManager.shared.friendRequest(state: DatabaseManager.RelationshipState.addFriend, for: user.username) { [weak self] succes in
            if !succes {
                print("failed to add friend")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }} else {
                    guard let username = UserDefaults.standard.string(forKey: "username") else {
                        return
                    }
                    
                    var profilePictureURL: String?
                    StorageManager.shared.profilePictureURL(for: username) { url in
                        
                        profilePictureURL = url?.absoluteString ?? ""
                        
                        let id = "\(username)_3"   
                        let model = TPNotification(identifier: id,
                                                   notificationType: 3,
                                                   profilePicture: profilePictureURL ?? "",
                                                   username: username,
                                                   dateString: String.dateString(from: Date()) ?? "Now",
                                                   postId: "",
                                                   postUrl: "")
                        
                        NotificationsManager.shared.create(notification: model, for: self!.user.username)
                        
                    }
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                    
                }
        }
    }
    
    func profileHeaderReusableViewDidTapRemoveFriend(_ profileHeader: ProfileHeaderCollectionReusableView) {
        DatabaseManager.shared.updateRelationship(state: DatabaseManager.RelationshipState.removeFriend, for: user.username) { [weak self] succes in
            if !succes {
                print("failed to remove friend")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
    
    func profileHeaderReusableViewDidTapRequested(_ profileHeader: ProfileHeaderCollectionReusableView) {
        DatabaseManager.shared.friendRequest(state: .removeFriend, for: user.username) { success in
            if !success {
                print("failed to remove friend")
            }else{
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
        
                DatabaseManager.shared.deleteNotificationsFromTarget(targetUsername: self.user.username) { success in
                    if !success {
                       print("failed on delete notification")
                    }
                }
            }
        }
    }
    
    func profileHeaderReusableViewDidTapProfilePicture(_ profileHeader: ProfileHeaderCollectionReusableView) {
        
    }
    
    
}

extension ProfileViewController{
    func configureCollectionView() {
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
           let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
           
           item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
           
           let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33)),
            subitem: item,
            count: 3)
           
           let section = NSCollectionLayoutSection(group: group)
           section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.60)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)]
           return section
           
        }))
        
        collectionView.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        
    }
    
   
    
}

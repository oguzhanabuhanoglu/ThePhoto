//
//  ProfileViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class ProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView?
   
    
    private let user: User
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
        let vc = ListViewController()
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
        var bio: String?
        var score: Int?
        
        let group = DispatchGroup()
        
        //DATA FOR COLLECTİON POSTS
        group.enter()
        DatabaseManager.shared.getPosts(for: username) { result in
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
                    bio = nil
                    score = nil
                }
        }
        
        //last image user shared
        
        
        
        //if profile is not for current user
        if !isCurrentUser {
            //get friendship state
            //i need to get informationa about is current user following
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username) { isFollowing in
                defer{
                    group.leave()
                }
                print(isFollowing)
                if isFollowing == true {
                    if didta
                    buttonType = .addFriend(friendshipStates.yes)
                }else if isFollowing == false {
                    buttonType = .addFriend(friendshipStates.no)
                }
              
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
    func profileHeaderReusableViewDidTapProfilePicture(_ profileHeader: ProfileHeaderCollectionReusableView) {
        
    }
    
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
        /*DatabaseManager.shared.updateRelationship(state: DatabaseManager.RelationshipState.addFriend, for: user.username)  { [weak self] succes in
            if !succes {
                print("failed to add friend")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }*/
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
       
        var profilePictureURL: String?
        StorageManager.shared.profilePictureURL(for: username) { url in
            
            profilePictureURL = url?.absoluteString ?? ""
            
            let id = NotificationsManager.newIdentifier()
            let model = TPNotification(identifier: id,
                                       notificationType: 3,
                                       profilePicture: profilePictureURL ?? "",
                                       username: username,
                                       dateString: String.dateString(from: Date()) ?? "Now",
                                       postId: "",
                                       postUrl: "")
            
            NotificationsManager.shared.create(notification: model, for: self.user.username)
            profileButtonType.addFriend(friendshipStates.maybe)
            
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

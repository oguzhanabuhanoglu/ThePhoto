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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
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
        //profile picture url
        StorageManager.shared.profilePictureURL(for: user.username) { url in
            
        }
        
        //name, bio, challange score
        
        //last image user shared
        
        //if profile is not for current user
        if !isCurrentUser {
            //get friendship state
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        cell.configure(debug: "sisifos")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let viewModel = ProfileHeaderViewModel(profilePictureUrl: URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg"),
                                               name: "Oğuzhan Abuhanoğlu",
                                               bio: "selamunaleykum",
                                               challangeScore: 24550,
                                               dailyImage: nil,
                                               buttonType: self.isCurrentUser ? .edit : .addFriend(isFriend: false))
        header.configure(with: viewModel)
        header.delegate = self
        return header
    }

}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderReusableViewDidTapProfilePicture(_ profileHeader: ProfileHeaderCollectionReusableView) {
        
    }
    
    func profileHeaderReusableViewDidTapEditProfile(_ profileHeader: ProfileHeaderCollectionReusableView) {
        
    }
    
    func profileHeaderReusableViewDidTapAddFriend(_ profileHeader: ProfileHeaderCollectionReusableView) {
        
    }
    
    func profileHeaderReusableViewDidTapRemoveFriend(_ profileHeader: ProfileHeaderCollectionReusableView) {

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

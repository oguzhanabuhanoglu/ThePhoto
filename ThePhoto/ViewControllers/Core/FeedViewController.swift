//
//  ViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private var collectionView: UICollectionView?
    private var feedHeaderView = FeedHeaderView()
   
    private var viewModels = [[FeedCellTypes]]()
    
    private var allPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "The Photo"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapNotifications))
        view.addSubview(feedHeaderView)
        feedHeaderView.delegate = self
        configurationCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPost()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedHeaderView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height * 0.065)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + view.frame.height * 0.065 , width: view.frame.width, height: view.frame.height * 0.935 - view.safeAreaInsets.top)
        
    }
    
    @objc func didTapNotifications() {
        let vc = NotificationsViewController()
        vc.title = "Notifications"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func fetchPost(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        self.viewModels.removeAll()
        let userGroup = DispatchGroup()
        userGroup.enter()
        
        var allPosts: [Post] = []
        
        DatabaseManager.shared.getFriends(for: username) { usernames in
            defer {
                userGroup.leave()
            }
            
            let users = usernames + [username]
            
            for current in users {
                userGroup.enter()
                DatabaseManager.shared.getPosts(for: current) { result in
                    defer{
                        userGroup.leave()
                    }
                    
                    switch result {
                    case .success(let posts):
                        allPosts.append(contentsOf: posts)
                        print(allPosts.count)
                    case .failure(let error):
                        break
                    }
                }
            }
        }
        
        userGroup.notify(queue: .main) {
            let group = DispatchGroup()
            self.allPosts = allPosts
            allPosts.forEach { model in
                group.enter()
                //self.viewModels.removeAll()
                self.createViewModel(model: model, username: model.postedBy) { success in
                    defer{
                        group.leave()
                    }
                    if !success{
                        print("failed  to create VM")
                    }
                }
            }
           
            group.notify(queue: .main) {
                allPosts = allPosts.sorted(by: { first, second in
                var date1 = first.date
                var date2 = second.date
                    print(allPosts[0].postedDate)
                    print(allPosts[1].postedDate)
                    return date1! > date2!
                })
                
               
                self.viewModels = self.viewModels.sorted(by: { first, second in
                    var date1: Date?
                    var date2: Date?
                    first.forEach { type in
                        switch type {
                        case .timesTamp(let viewModel):
                            date1 = viewModel.date
                        default:
                            break
                        }
                    }
                    second.forEach { type in
                        switch type {
                        case .timesTamp(let viewModel):
                            date2 = viewModel.date
                        default:
                            break
                        }
                    }
                    
                    if let date1 = date1, let date2 = date2{
                        return date1 > date2
                    }
                    return false
                })
                self.collectionView?.reloadData()
            }
        }
    }
        
        private func createViewModel(model: Post, username: String, completion: @escaping (Bool) -> Void){
            
            guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
            StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureUrl in
                guard let postURL = URL(string: model.postUrl),let profilePictureURL = profilePictureUrl else {
                    completion(false)
                    return
                }
                
                let isLiked = model.likers.contains(currentUsername)
                
                let postData: [FeedCellTypes] = [
                    .poster(viewModel: PosterCollectionViewCellViewModel(username: username,profilePictureURL: profilePictureURL)),
                    .post(viewModel: PostCollectionViewCellViewModel(postUrl: postURL)),
                    .actions(viewModel: PostActionsCollectionViewCellViewModel(postID: model.id, isLiked: isLiked, likers: model.likers)),
                    .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: username, caption: model.caption)),
                    .timesTamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()))
                ]
                
                self?.viewModels.append(postData)
                completion(true)
            }
            
        }
        
        
        //COLLECTION VIEW
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            //return viewModels.count == 0 ? 1  : viewModels.count
            return viewModels.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            /*if viewModels.count > 0 {
                return viewModels[section].count
            } else {
                return 0
            }*/
            viewModels[section].count
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cellType = viewModels[indexPath.section][indexPath.row]
            
            switch cellType{
            case .poster(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                    fatalError()
                }
                cell.configure(with: viewModel)
                cell.delegate = self
                return cell
                
            case .post(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
                    fatalError()
                }
                cell.configure(with: viewModel)
                return cell
                
            case .actions(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostActionsCollectionViewCell.identifier, for: indexPath) as? PostActionsCollectionViewCell else {
                    fatalError()
                }
                cell.configure(with: viewModel, index: indexPath.section)
                cell.delegate = self
                return cell
                
            case .caption(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCaptionCollectionViewCell.identifier, for: indexPath) as? PostCaptionCollectionViewCell else {
                    fatalError()
                }
                cell.configure(with: viewModel)
                return cell
                
            case .timesTamp(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostedDateCollectionViewCell.identifier, for: indexPath) as? PostedDateCollectionViewCell else {
                    fatalError()
                }
                cell.configure(with: viewModel)
                return cell
            }
        }

    
    
 
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedChallangeHeaderCollectionReusableView.identifier, for: indexPath) as! FeedChallangeHeaderCollectionReusableView
            headerView.delegate = self
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }

    
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 17)
    }*/
        
        
}
    
    




// MARK: Extensions


extension FeedViewController: FeedHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didTapCameraButton() {
        let sheet = UIAlertController(title: "New Challange Time", message: "Share new post", preferredStyle: UIAlertController.Style.actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Choose a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        present(sheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        let vc = PostShareViewController(image: image)
        navigationController?.pushViewController(vc, animated: true)
        dismiss(animated: true)
    }
    
    
}

/*extension FeedViewController: FeedChallangeHeaderCollectionReusableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didTapCameraButton() {
        let sheet = UIAlertController(title: "New Challange Time", message: "Share new post", preferredStyle: UIAlertController.Style.actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Choose a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        present(sheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        let vc = PostShareViewController(image: image)
        navigationController?.pushViewController(vc, animated: true)
        dismiss(animated: true)
    }
    
}*/

extension FeedViewController: PosterCollectionViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        present(actionSheet, animated: true)
    }
    
    func reportPost(){
        
    }
    
    func didTapUsername() {
        let vc = ProfileViewController(user: User(username: "Oguzhan", email: "Oguzhanabuhanoglu@gmail.com"))
        navigationController?.pushViewController(vc, animated: true)
    }
}
    
    
    
extension FeedViewController: PostActionsCollectionViewCellDelegate {
    func didTapLikeButton(_ cell: PostActionsCollectionViewCell, index: Int, isLiked: Bool) {
        let tuple = allPosts[index]
        DatabaseManager.shared.updateLikeState(state: isLiked ? .like : .unlike, postID: tuple.id, owner: tuple.postedBy) { success in
            guard success else {
                print("failed")
                return
            }
        }
    }
    
    func didTapCommentButton(_ cell: PostActionsCollectionViewCell, index: Int) {
        if index <= allPosts.count{
            let post = allPosts[index]
            let popupView = CommentsPopUpView(frame: CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: (view.frame.size.height / 10) * 8), post: post)
                    
            popupView.showInView(view: self.view)
        }else{
            print("index out of range")
        }
    }
    
    
    func didTapLikeCount(_ cell: PostActionsCollectionViewCell, index: Int) {
        let vc = ListViewController(type: .likers(usernames: allPosts[index].likers))
        vc.title = "Likers"
        navigationController?.pushViewController(vc, animated: true)
        }
}
    
    //CREATE COLLECTİON VİEW WİTH COMPOSITIONAL LAYOUT
    extension FeedViewController {
        func configurationCollectionView(){
            let sectionHeight : CGFloat = 130 + view.frame.size.width
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
                
             
                //items
                let posterItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(52))
                )
                
                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1))
                )
                
                let actionsItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(38))
                )
                
                let captionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(20))
                )
                
                let timesTampItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(20))
                )
                
                //group
                //let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)) ,repeatingSubitem: item ,count: 1)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)),
                                                             subitems: [
                                                                posterItem,
                                                                postItem,
                                                                actionsItem,
                                                                captionItem,
                                                                timesTampItem
                                                             ])
              
                
                //section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 7, trailing: 10)
                    
                // Boundary Supplementary Item olarak header'ı ekleme
                /*let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
                //if index == 0 {
                    //section.boundarySupplementaryItems = [sectionHeader]
                //}*/
                return section
                            
                
            }))
            collectionView.backgroundColor = .secondarySystemBackground
            //registers
            //collectionView.register(FeedChallangeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedChallangeHeaderCollectionReusableView.identifier)
            
            collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
            collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
            collectionView.register(PostActionsCollectionViewCell.self, forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier)
            collectionView.register(PostCaptionCollectionViewCell.self, forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier)
            collectionView.register(PostedDateCollectionViewCell.self, forCellWithReuseIdentifier: PostedDateCollectionViewCell.identifier)
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            self.collectionView = collectionView
            view.addSubview(collectionView)
        }
        
        
        
        
  
    }
    





// MARK: NOTE

//MOCK DATA
/*func fetchPost(){
    let postData: [FeedCellTypes] = [
        .poster(viewModel: PosterCollectionViewCellViewModel(username: "Oguzhan",
                                                             profilePictureURL:
                                                                URL(string:"https://iosacademy.io/assets/images/brand/icon.jpg")!)),
        .post(viewModel: PostCollectionViewCellViewModel(postUrl:
                                                            URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg")!)),
        .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: true, likers: ["annen"])),
        .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: "Oguzhan", caption: "zınıltısyon")),
        .timesTamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: Date()))
    ]
    
    let postData2: [FeedCellTypes] = [
        .poster(viewModel: PosterCollectionViewCellViewModel(username: "Oguzhan",
                                                             profilePictureURL:
                                                                URL(string:"https://iosacademy.io/assets/images/brand/icon.jpg")!)),
        .post(viewModel: PostCollectionViewCellViewModel(postUrl:
                                                            URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg")!)),
        .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: true, likers: ["annen"])),
        .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: "Oguzhan", caption: "zınıltısyon")),
        .timesTamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: Date()))
    ]
    
    viewModels.append(postData)
    viewModels.append(postData2)
    collectionView?.reloadData()
}*/

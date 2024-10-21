//
//  PostViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 8.01.2024.
//

import UIKit

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private let post: Post
    
    private var collectionView: UICollectionView?
    private var viewModels = [FeedCellTypes]()
   
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "post"
        view.backgroundColor = .systemBackground
        configurationCollectionView()
        fetchPost()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
       
        
    }
    
    
    
    private func fetchPost(){
        DatabaseManager.shared.getPost(with: post.id, from: post.postedBy) { post in
            guard let post = post else {
                return
            }
            
            self.createViewModel(model: post, username: post.postedBy) { success in
                guard success else {
                    print("failed when create vm")
                    return
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }

    private func createViewModel(model: Post, username: String, completion: @escaping (Bool) -> Void){
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else{return}
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
            
            self?.viewModels = postData
            completion(true)
        }
        
    }
    
    //COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.row]
        
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
            cell.configure(with: viewModel, index: indexPath.row)
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


}



// MARK: Extensions


extension PostViewController: PostActionsCollectionViewCellDelegate {
    func didTapLikeButton(_ cell: PostActionsCollectionViewCell, index: Int, isLiked: Bool) {
        DatabaseManager.shared.updateLikeState(state: isLiked ? .like : .unlike, postID: post.id, owner: post.postedBy) { success in
            guard success else {
                print("failed")
                return
            }
        }
    }
    
    func didTapCommentButton(_ cell: PostActionsCollectionViewCell, index: Int) {
        let popupView = CommentsPopUpView(frame: CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: (view.frame.size.height / 10) * 8), post: post)
                
        popupView.showInView(view: self.view)
    }
    
    
    func didTapLikeCount(_ cell: PostActionsCollectionViewCell, index: Int) {
        let vc = ListViewController(type: .likers(usernames: post.likers))
        vc.title = "Likers"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

extension PostViewController: PosterCollectionViewCellDelegate {
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




//CREATE COLLECTİON VİEW WİTH COMPOSITIONAL LAYOUT
extension PostViewController {
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
            return section
                        
            
        }))
        collectionView.backgroundColor = .secondarySystemBackground
        //registers
        collectionView.register(FeedChallangeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedChallangeHeaderCollectionReusableView.identifier)
        
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




//
//  ViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    private var collectionView: UICollectionView?
    private var viewModels = [[FeedCellTypes]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "The Photo"
        view.backgroundColor = .systemBackground
        configurationCollectionView()
        fetchPost()
    
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        
    }
    
    
    private func fetchPost(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        DatabaseManager.shared.getPosts(for: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let posts):
                    
                    let group = DispatchGroup()
                    
                    posts.forEach { model in
                        group.enter()
                        self?.createViewModel(model: model, username: username, completion: { success in
                            defer {
                                group.leave()
                            }
                            if !success{
                                print("failed when creating vm")
                            }
                        })
                        
                        group.notify(queue: .main) {
                            self?.collectionView?.reloadData()
                        }
                    
                   /* posts.forEach { model in
    
                        self?.createViewModel(model: model, username: username, completion: { success in
                    
                            if !success{
                                print("failed when creating vm")
                            }else{
                                self?.collectionView?.reloadData()
                            }
                        })*/
                    }
                case.failure(let error):
                    print(error)
                }
            }
        }
        
        
    }
    
    
    private func createViewModel(model: Post, username: String, completion: @escaping (Bool) -> Void){
            
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureUrl in
            guard let postURL = URL(string: model.postUrl),let profilePictureURL = profilePictureUrl else {
                return
            }
            let postData: [FeedCellTypes] = [
                .poster(viewModel: PosterCollectionViewCellViewModel(username:username,profilePictureURL: profilePictureURL)),
                .post(viewModel: PostCollectionViewCellViewModel(postUrl: postURL)),
                .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: false, likers: [])),
                .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: username, caption: model.caption)),
                .timesTamp(viewModel: PostDatetimeCollectionViewCellViewModel(date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()))
            ]
                           
            self?.viewModels.append(postData)
            completion(true)
        }
            
    }
    

    
    
    
    
    //COLLECTION VIEW
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
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
         cell.configure(with: viewModel)
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
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedChallangeHeaderCollectionReusableView.identifier, for: indexPath) as! FeedChallangeHeaderCollectionReusableView
            headerView.delegate = self
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    


    
}



///////////////////////////---EXTENSİONS---////////////////////

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

extension FeedViewController: FeedChallangeHeaderCollectionReusableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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


extension FeedViewController: PostActionsCollectionViewCellDelegate {
    func didTapLikeButton(isLiked: Bool) {
        //call database to update like state
    }
    
    func didTapCommentButton() {
        let vc = PostViewController()
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapLikeCount() {
        let vc = ListViewController()
        vc.title = "List"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//CREATE COLLECTİON VİEW WİTH COMPOSITIONAL LAYOUT
extension FeedViewController {
    func configurationCollectionView(){
        let sectionHeight : CGFloat = 180 + view.frame.size.width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
            //header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let layoutHeader1 = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            



            //items
            let posterItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(60))
            )
            
            let postItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(1))
            )
            
            let actionsItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(40))
            )
            
            let captionItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(60))
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            /*if index == 0 {
                section.boundarySupplementaryItems = [layoutHeader1]
            }*/
            
            return section
            

        }))
    

        
        collectionView.backgroundColor = .blue
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


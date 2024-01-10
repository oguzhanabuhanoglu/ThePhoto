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
        collectionView?.frame = CGRect(x: 0, y: view.frame.height / 17, width: view.frame.width, height: view.frame.height - (view.frame.height / 17))
        
    }
    
    
    //MOCK DATA
    func fetchPost(){
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
            return headerView
        } else {
            return UICollectionReusableView()
        }
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
        //let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: FeedChallangeHeaderCollectionReusableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didTapCameraButton() {
        let sheet = UIAlertController(title: "New challange time", message: "Share daily post", preferredStyle: UIAlertController.Style.actionSheet)
        
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
            if index == 0 {
                section.boundarySupplementaryItems = [layoutHeader1]
            }
            
            return section
            

        }))
    

        
        collectionView.backgroundColor = .systemBackground
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


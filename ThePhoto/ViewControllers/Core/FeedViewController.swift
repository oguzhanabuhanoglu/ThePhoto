//
//  ViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var collectionView: UICollectionView?
    private var viewModels = [[FeedCellTypes]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "The Photo"
        view.backgroundColor = .systemBackground
        configurationCollectionView()
        fetchPost()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
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
        
        viewModels.append(postData)
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



extension FeedViewController {
    func configurationCollectionView(){
        let sectionHeight : CGFloat = 180 + view.frame.size.width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
            
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            return section
        }))
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.register(PostActionsCollectionViewCell.self, forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier)
        collectionView.register(PostCaptionCollectionViewCell.self, forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier)
        collectionView.register(PostedDateCollectionViewCell.self, forCellWithReuseIdentifier: PostedDateCollectionViewCell.identifier)
        
        self.collectionView = collectionView
        
        
    }
}


//
//  PostShareViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 12.01.2024.
//

import UIKit
import FirebaseFirestore

class PostShareViewController: UIViewController {
    
    private let challangeLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.secondaryLabel.cgColor
        label.numberOfLines = 2
        label.text = "with your best friend from school"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 18)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 15)
        label.text = "Add Caption"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let captionText : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return textView
    }()
    
    private var image = UIImage()

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "New Challenge Post"
        
        imageView.image = image
        view.addSubview(challangeLabel)
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        view.addSubview(captionText)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapShareButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let widht = view.frame.width
        let height = view.frame.height
        
        let imageSize = widht / 3.5
        
        challangeLabel.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: view.safeAreaInsets.top + 30, width: widht * 0.9, height: height * 0.05)
        imageView.frame = CGRect(x: 5, y: height * 0.21, width: imageSize, height: imageSize)
        infoLabel.frame = CGRect(x: 10 + imageSize, y: height * 0.21, width: widht - imageSize - 15, height: height * 0.04)
        captionText.frame = CGRect(x: 10 + imageSize, y: height * 0.25, width: widht - imageSize - 15, height: imageSize - (height * 0.04))
    }
    
    @objc func didTapCloseButton() {
        self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 1
    }

    @objc func didTapShareButton(){
        let username = UserDefaults.standard.string(forKey: "username")
        var caption = captionText.text ?? ""
        if caption == "" {
            caption = challangeLabel.text ?? ""
        }
        //Upload post, update database
        
        //generate post ID
        guard let newPostID = createNewPostID() else {
            return
        }
        //Upload post
        StorageManager.shared.uploadPost(data: image.pngData(), id: newPostID) { newPostDownloadURL in
            guard let url = newPostDownloadURL else{
                return
            }
            
            //new post
            let newPost = Post(postedBy: username!,
                               id: newPostID,
                               postUrl: url.absoluteString,
                               caption: caption,
                               postedDate: String.dateString(from: Date()) ?? "",
                               likers: [])
            
            //update database
            DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
                guard finished else {
                    return
                }
                DispatchQueue.main.async {
                    self?.tabBarController?.tabBar.isHidden = false
                    self?.tabBarController?.selectedIndex = 1
                    self?.navigationController?.popToRootViewController(animated: false)
                    
                    
                }
            }
        }
    }
    
    private func createNewPostID() -> String? {
        let timeStamp = Date().timeIntervalSince1970
        let randomNumber = Int.random(in: 0...1000)
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        
        return "\(username)_\(randomNumber)_\(timeStamp)"
    }
    
}

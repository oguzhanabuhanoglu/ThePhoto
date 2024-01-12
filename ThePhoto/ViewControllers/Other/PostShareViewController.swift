//
//  PostShareViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 12.01.2024.
//

import UIKit

class PostShareViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let captionText : UITextView = {
        let textView = UITextView()
        textView.text = "Add Caption..."
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
        view.addSubview(imageView)
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
        
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.width)
        captionText.frame = CGRect(x: 10, y: view.frame.height * 0.60, width: view.frame.width - 20, height: view.frame.height * 0.15)
    }
    
    @objc func didTapCloseButton() {
        self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 1
    }

    @objc func didTapShareButton(){
        var caption = captionText.text ?? ""
        if caption == "Add Caption..." {
            caption = ""
        }
        //Upload post, update database
        
        //generate post ID
        guard let newPostID = createNewPostID() else {
            return
        }
        //Upload post
        StorageManager.shared.uploadPost(data: image.pngData(), id: newPostID) { success in
            guard success else{
                return
            }
            
            //new post
            let newPost = Post(id: newPostID,
                               caption: caption,
                               postedDate: String.dateString(from: Date()) ?? "",
                               likers: [])
            
            //update database
            DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
                guard finished else {
                    return
                }
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: false)
                    self?.tabBarController?.selectedIndex = 1
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

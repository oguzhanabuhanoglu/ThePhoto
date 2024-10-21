//
//  denemepopup.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 29.03.2024.
//

import UIKit

class CommentsPopUpView: UIView, CommentBarViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var post: Post
    private let commentBarView = CommentBarView()
    private var observer: NSObjectProtocol?
    var profileImageURL: URL?
    private var comments: [Comments] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return table
    }()
    
    init(frame: CGRect, post: Post){
        self.post = post
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 15
        layer.masksToBounds = true
        setupView()
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchComments()
        addSubview(commentBarView)
        observeKeyboadrChange()
        commentBarView.delegate = self
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.commentBarView.frame = CGRect(x: 0, y: frame.height - safeAreaInsets.bottom - 50, width: frame.width, height: 50)
        self.tableView.frame = CGRect(x: 0, y: 10, width: frame.width, height: frame.height - 60)
    }
    
    private func setupView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: self)
            switch recognizer.state {
            case .changed:
                self.frame.origin.y += translation.y
                recognizer.setTranslation(.zero, in: self)
            case .ended:
                // Pop-up'ı ekrandan tamamen gizleyelim
                if self.frame.origin.y > (superview?.frame.size.height ?? 0) * 0.2 { // Pop-up'ın 3/4'ü ekrandan aşağıda ise
                    hide()
                }
            default:
                break
            }
        }
    
        
        func showInView(view: UIView) {
            let popupHeight = (view.frame.size.height / 4) * 3 // Pop-up'ın yüksekliği ekranın 3/4'ü olacak şekilde ayarlanır
            let popupY = view.frame.size.height - popupHeight // Pop-up'ın yatay pozisyonu ayarlanır
            
            self.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: popupHeight) // Pop-up'ın görünümünü ayarlar
            view.addSubview(self)
            UIView.animate(withDuration: 0.3) {
                self.frame = CGRect(x: 0, y: popupY, width: view.frame.size.width, height: popupHeight) // Pop-up'ı görünür hale getirir
            }
        }
        
        func hide() {
            let popupHeight = (superview?.frame.size.height ?? 0) / 4 * 3 // Pop-up'ın yüksekliği ekranın 3/4'ü olacak şekilde ayarlanır
            
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect(x: 0, y: self.superview?.frame.size.height ?? 0, width: self.frame.size.width, height: popupHeight) // Pop-up'ı gizler
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    
    private func observeKeyboadrChange() {
        observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                                          object: nil,
                                                          queue: .main) { notification in
            guard let userinfo = notification.userInfo, let frame = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            //print(frame)
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(x: 0, y: self.frame.height - 50 - frame.height, width: self.frame.width, height: 50)
            }
            
        }
        
        observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                          object: nil,
                                                          queue: .main) { _ in
            self.commentBarView.frame = CGRect(x: 0, y: self.frame.height - self.safeAreaInsets.bottom - 50, width: self.frame.width, height: 50)
        }
    }
    
    
    func commentBarViewDidTapShare(_ commentBarView: CommentBarView, withText text: String) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        StorageManager.shared.profilePictureURL(for: username) { url in
            guard let url = url else {
                return
            }
            self.profileImageURL = url
            DatabaseManager.shared.createComments(comment: Comments(profilePicture: self.profileImageURL, username: username, commment: text, dateString: String.dateString(from: Date()) ?? ""),
                                                  postID: self.post.id,
                                                  username: self.post.postedBy) { success in
                
                DispatchQueue.main.async {
                    guard success else {
                        return
                    }
                }
            }
        }
        
    }
    
    private func fetchComments() {
        DatabaseManager.shared.getComments(postID: post.id, username: post.postedBy) { comments in
            self.comments.append(contentsOf: comments)
            DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            fatalError()
        }
        cell.configure(with: comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.height * 0.06
    }
    
}



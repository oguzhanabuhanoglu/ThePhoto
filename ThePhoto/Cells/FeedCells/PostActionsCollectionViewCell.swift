//
//  PostActionsCollectionViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate : AnyObject {
    func didTapLikeButton(_ cell: PostActionsCollectionViewCell, index: Int, isLiked: Bool)
    func didTapCommentButton(_ cell: PostActionsCollectionViewCell, index: Int)
    func didTapLikeCount(_ cell: PostActionsCollectionViewCell, index: Int)
}

class PostActionsCollectionViewCell: UICollectionViewCell {

    static let identifier = "PostActionsCollectionViewCell"
    
    weak var delegate: PostActionsCollectionViewCellDelegate?
    
    private var isLiked = false
    var postID: String = ""
    
    let likeButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: UIControl.State.normal)
        button.tintColor = .label
        return button
    }()
    
    let commentButon : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28))
        button.setImage(image, for: UIControl.State.normal)
        button.tintColor = .label
        return button
    }()
    
    let likersLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButon)
        contentView.addSubview(likersLabel)
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: UIControl.Event.touchUpInside)
        commentButon.addTarget(self, action: #selector(didTapCommentButton), for: UIControl.Event.touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLikersLabel))
        likersLabel.isUserInteractionEnabled = true
        likersLabel.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        let size = height - 6
        likeButton.frame = CGRect(x: 8, y: 3, width: size, height: size)
        commentButon.frame = CGRect(x: widht * 0.15 , y: 3, width: size, height: size)
        likersLabel.frame = CGRect(x: widht * 0.66, y: height * 0.5 - (height * 0.8) / 2, width: widht * 0.3, height: height * 0.8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with viewModel: PostActionsCollectionViewCellViewModel){
        let users = viewModel.likers
        likersLabel.text = "\(users.count)"
        postID = viewModel.postID
        if viewModel.isLiked {
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: UIControl.State.normal)
            likeButton.tintColor = .red
        }
        
        
    }
    
    @objc func didTapLikeButton() {
        if self.isLiked {
            let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: UIControl.State.normal)
            likeButton.tintColor = .label
        }else{
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: UIControl.State.normal)
            likeButton.tintColor = .red
        }
        self.isLiked = !isLiked
        delegate?.didTapLikeButton(self, index: 0, isLiked: !isLiked)
    }
    
    @objc func didTapCommentButton() {
        delegate?.didTapCommentButton(self, index: 0)
    }
    
    @objc func didTapLikersLabel(){
        delegate?.didTapLikeCount(self, index: 0)
    }


}


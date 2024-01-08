//
//  PostActionsCollectionViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate : AnyObject {
    func didTapLikeButton()
    func didTapCommentButton()
}

class PostActionsCollectionViewCell: UICollectionViewCell {

    static let identifier = "PostActionsCollectionViewCell"
    
    weak var delegate : PostActionsCollectionViewCellDelegate?
    
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
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.secondaryLabel.cgColor
        label.layer.cornerRadius = 15
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        let size = height - 6
        likeButton.frame = CGRect(x: 5, y: 3, width: size, height: size)
        commentButon.frame = CGRect(x: widht * 0.15 , y: 3, width: size, height: size)
        likersLabel.frame = CGRect(x: widht * 0.67, y: height * 0.5 - (height * 0.8) / 2, width: widht * 0.3, height: height * 0.8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with viewModel: PostActionsCollectionViewCellViewModel){
        let users = viewModel.likers
        likersLabel.text = "\(users.count)"
        if viewModel.isLiked {
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: UIControl.State.normal)
            likeButton.tintColor = .red
        }
        
        
    }
    
    @objc func didTapLikeButton() {
        delegate?.didTapLikeButton()
    }
    
    @objc func didTapCommentButton() {
        delegate?.didTapCommentButton()
    }


}


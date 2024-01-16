//
//  PosterCollectionViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit
import SDWebImage

protocol PosterCollectionViewCellDelegate : AnyObject {
    func didTapMoreButton()
    func didTapUsername()
}

class PosterCollectionViewCell: UICollectionViewCell {

    static let identifier = "PosterCollectionViewCell"
    
    weak var delegate: PosterCollectionViewCellDelegate?
    
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .systemBackground
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return label
    }()
    
    private let moreButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
        button.setImage(image, for: UIControl.State.normal)
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: UIControl.Event.touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dadTapUsername))
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        let size = height - 6
        profileImageView.frame = CGRect(x: 3, y: 3, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
        
        usernameLabel.frame = CGRect(x: widht * 0.51 - (widht * 0.7) / 2, y: 2, width: widht * 0.7, height: size)
        
        moreButton.frame = CGRect(x: widht - size - 3, y: 2, width: size, height: size)
    }
    
    public func configure(with viewModel: PosterCollectionViewCellViewModel){
        profileImageView.sd_setImage(with: viewModel.profilePictureURL, completed: nil)
        usernameLabel.text = viewModel.username
    }

    
    @objc func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }
    
    @objc func dadTapUsername() {
        delegate?.didTapUsername()
    }

}

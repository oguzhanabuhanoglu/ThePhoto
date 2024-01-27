//
//  LikeTableViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    static let identifier = "LikeTableViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont(name: "Helvetica", size: 14)
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        addSubview(profileImageView)
        addSubview(label)
        addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        let size = height - 10
        profileImageView.frame = CGRect(x: 3, y: 5, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
        
        let size2 = height - 6
        postImageView.frame = CGRect(x: widht - size2 - 2, y: 3, width: size2, height: size2)
    
        let labelSize = label.sizeThatFits(CGSize(width: widht - size - size2 - 9, height: height))
        label.frame = CGRect(x: widht * 0.52  - (widht * 0.7) / 2, y: 2, width: labelSize.width, height: height)
        
       
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
        label.text = nil
        postImageView.image = nil
    }
    
    public func configure(with viewModel: LikeCellViewModel){
        label.text = viewModel.username + " liked your challange"
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        postImageView.sd_setImage(with: viewModel.postUrl, completed: nil)
    }

}

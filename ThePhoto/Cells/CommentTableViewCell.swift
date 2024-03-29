//
//  CommentTableViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 29.03.2024.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    private let profilePicture : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica", size: 15)
        label.textColor = .label
        label.backgroundColor = .systemBackground
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        addSubview(profilePicture)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height - 4
        profilePicture.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilePicture.layer.cornerRadius = size / 2
        label.frame = CGRect(x: 40, y: 3, width: contentView.frame.width - 40, height: contentView.frame.height - 6)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.image = nil
        label.text = nil
    }
    
    func configure(with model: Comments){
        profilePicture.sd_setImage(with: model.profilePicture, completed: nil)
        label.text = "\(model.username): \(model.commment)"
    }
}

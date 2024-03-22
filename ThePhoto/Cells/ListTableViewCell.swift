//
//  ListTableViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 21.03.2024.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    static let identifier = "ListTableViewCell"
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        clipsToBounds = true
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        usernameLabel.text = nil
        nameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        let size = contentView.frame.height - 10
        profileImage.frame = CGRect(x: 3, y: 5, width: size, height: size)
        profileImage.layer.cornerRadius = size / 2
        
        usernameLabel.frame = CGRect(x: size + 12, y: height * 0.2, width: widht * 0.7, height: height * 0.3)
        nameLabel.frame = CGRect(x: size + 12, y: height * 0.5, width: widht * 0.7, height: height * 0.3)
    }
    
    func configure(with viewModel: ListUserCellViewModel){
        usernameLabel.text = viewModel.username
        StorageManager.shared.profilePictureURL(for: viewModel.username) { url in
            DispatchQueue.main.async {
                self.profileImage.sd_setImage(with: url, completed: nil)
            }
        }
        DatabaseManager.shared.getUserInfo(username: viewModel.username) { userinfo in
            DispatchQueue.main.async {
                self.nameLabel.text = userinfo?.name
            }
            
        }
        
    }
    
    
}

//
//  FriendRequestTableViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import UIKit

/*protocol FriendRequestNotificationTableViewCellDelegate: AnyObject {
    func FriendRequestNotificationTableViewCell(_ cell: FriendRequestTableViewCell, didTapAcceptButton)
}*/

class FriendRequestTableViewCell: UITableViewCell {

    static let identifier = "FriendRequestTableViewCell"
    
   // weak var delegate:
    
    //private var viewModel: FriendRequestCellViewModel
    
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = UIFont(name: "Helvetica", size: 11)
        return label
    }()
    
    private let acceptButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
        //button.setTitle("accept", for: UIControl.State.normal)
        button.tintColor = .label
        return button
    }()
    
    private let declineButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: UIControl.State.normal)
        button.tintColor = .label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        addSubview(profileImageView)
        addSubview(label)
        addSubview(acceptButton)
        addSubview(declineButton)
        addSubview(dateLabel)
        
        declineButton.addTarget(self, action: #selector(didTapDeclineButton), for: UIControl.Event.touchUpInside)
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: UIControl.Event.touchUpInside)
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
        let dateLabelSize = dateLabel.sizeThatFits(CGSize(width: widht - size - size2 - 9, height: height * 0.1))
        let labelSize = label.sizeThatFits(CGSize(width: widht - size - size2 - 9, height: height))
        
        label.frame = CGRect(x: widht * 0.52  - (widht * 0.7) / 2, y: 2, width: labelSize.width, height: height - dateLabelSize.height - 2)
        
        dateLabel.frame = CGRect(x: widht * 0.52  - (widht * 0.7) / 2, y: 3 + label.frame.height , width: dateLabelSize.width, height: dateLabelSize.height)
        
        let size3 = height / 2
        declineButton.frame = CGRect(x: widht - size3 - 12, y: (height - size3) / 2, width: size3, height: size3)
        
        acceptButton.frame = CGRect(x: widht - (size3 * 2) - 30, y: (height - size3) / 2, width: size3, height: size3)
        
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    @objc func didTapDeclineButton() {
       
    }
    
    @objc func didTapAcceptButton() {
    }
    
    
    public func configure(with viewModel: FriendRequestCellViewModel){
        label.text = viewModel.username + " want to be your friend"
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        dateLabel.text = viewModel.date
        
    }
    
    
}

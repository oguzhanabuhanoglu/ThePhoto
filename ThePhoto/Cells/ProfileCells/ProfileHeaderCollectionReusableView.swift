//
//  ProfileHeaderCollectionReusableView.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 2.02.2024.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate : AnyObject {
    func profileHeaderReusableViewDidTapProfilePicture(_ profileHeader: ProfileHeaderCollectionReusableView)
    func profileHeaderReusableViewDidTapEditProfile(_ profileHeader: ProfileHeaderCollectionReusableView)
    func profileHeaderReusableViewDidTapAddFriend(_ profileHeader: ProfileHeaderCollectionReusableView)
    func profileHeaderReusableViewDidTapRemoveFriend(_ profileHeader: ProfileHeaderCollectionReusableView)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate : ProfileHeaderCollectionReusableViewDelegate?
    
    private var action = profileButtonType.edit
    
    private let profileImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "sisifos")
        return image
    }()
    
    private let challangeScoreButton : UIButton = {
        let button = UIButton()
        button.setTitle("2245", for: UIControl.State.normal)
        button.setTitleColor(.label, for: UIControl.State.normal)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 0.4
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let bioLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Oğuzhan Abuhanoğlu\nThat's my fucking library"
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private let dailyChallangeLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.text = "Daily Challange"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        return label
    }()
    
    private let dailyImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = . secondarySystemBackground
        //image.image = UIImage(named: "pp")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.secondaryLabel.cgColor
        return image
    }()
    
    private let actionButton : UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(profileImageView)
        addSubview(challangeScoreButton)
        addSubview(bioLabel)
        addSubview(dailyImageView)
        addSubview(actionButton)
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = frame.size.width
        let height = frame.size.height
        
        let size = widht / 4
        profileImageView.frame = CGRect(x: widht / 4 - (size / 2), y: 10, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
    
        challangeScoreButton.frame = CGRect(x: widht / 4 - (widht / 10), y: size + 20, width: widht / 5.5, height: 15)
        
        bioLabel.sizeToFit()
        let labelHeight = bioLabel.frame.size.height
        bioLabel.frame = CGRect(x: 5 , y: size + 45, width: widht * 0.5, height: labelHeight)
        
        dailyImageView.frame = CGRect(x: widht * 0.75  - (widht * 0.45) / 2, y: 5, width: widht * 0.45, height: widht * 0.54)
        
        actionButton.frame = CGRect(x: 2, y: height * 0.80 , width: (widht / 2) - 4, height: height * 0.12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        bioLabel.text = nil
    }
    
    private func addAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePicture))
        profileImageView.addGestureRecognizer(tap)
        actionButton.addTarget(self, action: #selector(didTapAcitonButton), for: .touchUpInside)
        
    }
    
    @objc func didTapProfilePicture() {
        delegate?.profileHeaderReusableViewDidTapProfilePicture(self)
    }
    
    
    
    
    public func configure(with viewModel: ProfileHeaderViewModel){
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        
        var text = ""
        if let name = viewModel.name {
            text = name + "\n"
        }
        text += viewModel.bio ?? "welcome"
        bioLabel.text = text
        
        
        dailyImageView.sd_setImage(with: viewModel.dailyImage, completed: nil)
        challangeScoreButton.setTitle("\(viewModel.challangeScore)", for: .normal)
        
        // button type
        switch viewModel.buttonType {
        case .edit:
            actionButton.backgroundColor = .systemBackground
            actionButton.setTitle("Edit Profile", for: UIControl.State.normal)
            actionButton.setTitleColor(.label, for: UIControl.State.normal)
            actionButton.layer.borderWidth = 0.6
            actionButton.layer.borderColor = UIColor.secondaryLabel.cgColor
            
        case .addFriend(let isFriend):
            DatabaseManager.isFriend = isFriend
            self.action = profileButtonType.addFriend(isFriend: isFriend)
            updateRelationshipButton()
        }
    }
    
    
    @objc func didTapAcitonButton() {
        switch action {
        case.edit:
            delegate?.profileHeaderReusableViewDidTapEditProfile(self)
        case.addFriend:
            if DatabaseManager.isFriend {
                
                delegate?.profileHeaderReusableViewDidTapRemoveFriend(self)
                DatabaseManager.isFriend = !DatabaseManager.isFriend
                updateRelationshipButton()
            }else{
                
                actionButton.setTitle("Request sent", for: .normal)
                actionButton.backgroundColor = .tertiaryLabel
                actionButton.setTitleColor(.label, for: UIControl.State.normal)
                delegate?.profileHeaderReusableViewDidTapAddFriend(self)
                
                
                
            }
        }
        
    }
    func updateRelationshipButton() {
        actionButton.backgroundColor = DatabaseManager.isFriend ? .systemGray4 : .systemBlue
        actionButton.setTitle(DatabaseManager.isFriend ? "Remove Friend" : "Add Friend", for: .normal)
        actionButton.setTitleColor(DatabaseManager.isFriend ? .label : .white, for: .normal)
    }
    
    
}


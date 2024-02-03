//
//  ProfileHeaderCollectionReusableView.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 2.02.2024.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private let profileImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        //image.layer.borderColor = UIColor.secondaryLabel.cgColor
        //image.layer.borderWidth = 1
        image.image = UIImage(named: "sisifos")
        return image
    }()
    
    private let challangeScoreLabel : UILabel = {
        let label = UILabel()
        label.text = "2245"
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .systemBackground
        label.layer.borderColor = UIColor.secondaryLabel.cgColor
        label.layer.borderWidth = 0.7
        label.layer.cornerRadius = 10
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let bioLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Oğuzhan Abuhanoğlu\nThat's my fucking library"
        label.font = .systemFont(ofSize: 14)
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
        image.image = UIImage(named: "pp")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.secondaryLabel.cgColor
        return image
    }()
    
    private let actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.setTitle("Edit Profile", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        return button
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(profileImageView)
        addSubview(challangeScoreLabel)
        addSubview(bioLabel)
//        //addSubview(dailyChallangeLabel)
        addSubview(dailyImageView)
        addSubview(actionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = frame.size.width
        let height = frame.size.height
        
        let size = widht / 4
        profileImageView.frame = CGRect(x: 5, y: 10, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
    
        challangeScoreLabel.frame = CGRect(x: 10, y: size + 20, width: widht / 5, height: 20)
        
        bioLabel.sizeToFit()
        let labelHeight = bioLabel.frame.size.height
        bioLabel.frame = CGRect(x: 5 , y: size + 50, width: widht * 0.5, height: labelHeight)
        
        dailyImageView.frame = CGRect(x: widht * 0.75 - (widht * 0.4) / 2, y: 5, width: widht * 0.45, height: widht * 0.45)
        
        dailyChallangeLabel.frame = CGRect(x: widht * 0.5, y: 10 + (widht * 0.4), width: widht * 0.5, height: height * 0.12)
        
        actionButton.frame = CGRect(x: 5, y: height * 0.85 , width: widht - 10, height: height * 0.12)
        
        //size + labelHeight + 70
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //profileImageView.image = nil
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel){
        
    }
    
    
}

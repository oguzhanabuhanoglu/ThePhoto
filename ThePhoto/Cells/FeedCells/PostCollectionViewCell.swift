//
//  PostCollectionViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit
import SDWebImage

class PostCollectionViewCell: UICollectionViewCell {

    static let identifier = "PostCollectionViewCell"
    
    private let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func configure(with viewModel: PostCollectionViewCellViewModel){
        postImageView.sd_setImage(with: viewModel.postUrl, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        //postImageView.frame = contentView.bounds
        
        postImageView.frame = CGRect(x: 15, y: height / 2 - (widht - 30) / 2, width: widht - 30 , height: widht - 30)
        postImageView.layer.cornerRadius = 1
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
}

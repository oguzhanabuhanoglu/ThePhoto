//
//  PhotoCollectionViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 2.02.2024.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    private var imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //imageView.layer.cornerRadius = 15
        imageView.frame = contentView.bounds
        
    }
    
    /*override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }*/
    
    /*public func configure(with image: UIImage) {
        imageView.image = image
    }*/
    
    public func configure(with post: Post){
        imageView.sd_setImage(with: URL(string: post.postUrl))
    }
}

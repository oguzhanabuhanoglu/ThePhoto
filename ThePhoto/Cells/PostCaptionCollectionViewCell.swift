//
//  PostCaptionCollectionViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit

class PostCaptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCaptionCollectionViewCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica", size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = label.sizeThatFits(CGSize(width: contentView.bounds.size.width - 12, height: contentView.bounds.size.height))
        label.frame = CGRect(x: 12, y: 3, width: size.width, height: size.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: PostCaptionCollectionViewCellViewModel){
        label.text = "\(viewModel.username): \(viewModel.caption ?? "")"
    }
}

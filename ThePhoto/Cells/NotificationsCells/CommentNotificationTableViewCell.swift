//
//  CommentTableViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 26.01.2024.
//

import UIKit

protocol CommentNotificationTableViewCellDelegate : AnyObject{
    func commentNotificationTableViewCell(_ cell: CommentNotificationTableViewCell, didTapPostWith viewModel: CommentCellViewModel)
}

class CommentNotificationTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    weak var delegate: CommentNotificationTableViewCellDelegate?
    
    private var viewModel: CommentCellViewModel?
    
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
        
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.addGestureRecognizer(tap)
    }
    
    //bu fonksiyonun içinden de viewModela ulaşabilmek için sınıf altında viewModelı tanımladık.Bu fonksiyon ve configure fonksiyonu altında unwrap ettik.
    @objc func didTapPost(){
        guard let vm = viewModel else {
            return
        }
        delegate?.commentNotificationTableViewCell(self, didTapPostWith: vm)
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
    
    public func configure(with viewModel: CommentCellViewModel){
        self.viewModel = viewModel
        label.text = viewModel.username + " commented to your challange"
        profileImageView.sd_setImage(with: viewModel.profilePicturUrl, completed: nil)
        postImageView.sd_setImage(with: viewModel.postUrl, completed: nil)
    }
}

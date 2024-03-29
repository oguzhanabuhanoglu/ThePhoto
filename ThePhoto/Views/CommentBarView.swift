//
//  CommentBarView.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 28.03.2024.
//

import UIKit

protocol CommentBarViewDelegate: AnyObject {
    func commentBarViewDidTapShare(_ commentBarView: CommentBarView, withText text: String)
}

final class CommentBarView: UIView, UITextFieldDelegate {
    
    weak var delegate: CommentBarViewDelegate?
    
    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Comment..."
        field.textAlignment = .left
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.backgroundColor = .systemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: UIControl.State.normal)
        button.tintColor = .link
        button.backgroundColor = .systemBackground
        return button
    }()

    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        addSubview(textField)
        addSubview(button)
        textField.delegate = self
        button.addTarget(self, action: #selector(didTapShare), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = frame.width
        let height = frame.height
        
        textField.frame = CGRect(x: 3, y: 3, width: (widht * 0.9) - 6, height: height - 6)
        button.frame = CGRect(x: widht * 0.9 , y: 3 , width: widht * 0.1, height: height - 6)
        
        
    }
    
    @objc func didTapShare(){
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        delegate?.commentBarViewDidTapShare(self, withText: text)
        textField.resignFirstResponder()
        textField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didTapShare()
        return true
    }
    
}

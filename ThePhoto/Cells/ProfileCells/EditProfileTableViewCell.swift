//
//  EditProfileTableViewCell.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 25.02.2024.
//

import UIKit

protocol EditProfileTableViewCellDelegate {
    func editProfileTableVİewCell(_ cell: EditProfileTableViewCell, didupdateField updatedModel: EditProfileFormModel)
}

class EditProfileTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "EditProfileCell"
    private var model : EditProfileFormModel?
    public var delegate : EditProfileTableViewCellDelegate?
    
    let label : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.backgroundColor = .systemBackground
        return label
    }()
    
    let field : UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        field.backgroundColor = .systemBackground
        field.textColor = .label
        return field
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        label.frame = CGRect(x: 5, y: 0, width: widht * 0.3, height: height)
        field.frame = CGRect(x: (widht * 0.65) - widht * 0.3, y: 0, width: widht * 0.6, height: height)
    }
    
    public func configure(with model: EditProfileFormModel) {
        self.model = model
        label.text = model.label
        field.placeholder = model.placeholdet
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        field.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else{
            return true
        }
        delegate?.editProfileTableVİewCell(self, didupdateField: model)
        textField.resignFirstResponder()
        return true
    }
    
}

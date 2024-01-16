//
//  FeedChallangeHeaderView.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 15.01.2024.
//

import UIKit

/*protocol FeedChallangeHeaderViewDelegate : AnyObject {
    func didTapCameraButton()
}*/

class FeedChallangeHeaderView: UIView {

    /*static let identifier = "FeedChallangeHeaderView"
    
    weak var delegate : FeedChallangeHeaderViewDelegate?
    
    private let challangeLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.secondaryLabel.cgColor
        label.numberOfLines = 2
        label.text = "with your best friend from school"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 18)
        return label
    }()
    
    private let cameraButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.badge.clock"), for: UIControl.State.normal)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(challangeLabel)
        addSubview(cameraButton)
        cameraButton.addTarget(self, action: #selector(didTapCameraButton), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widht = frame.size.width
        let height = frame.size.height
        
        challangeLabel.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.5 - (height * 0.7) / 2, width: widht * 0.9, height: height * 0.7)
        cameraButton.frame = CGRect(x: widht * 0.93 - (widht * 0.07) / 2 , y: height * 0.72 - (widht * 0.07) / 2, width: widht * 0.07, height: widht * 0.07)
        cameraButton.layer.cornerRadius = (widht * 0.07) / 2
    }
    
    @objc func didTapCameraButton(){
        delegate?.didTapCameraButton()
    }*/
    
    
    
    

}

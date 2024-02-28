//
//  NameVC.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 25.02.2024.
//

import UIKit

class NameVC: UIViewController {
    
    struct Constants {
        static let cornerRadius : CGFloat = 8.0
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi, what's your name?"
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.font = UIFont(name: "Helvetica", size: 25)
        return label
    }()

    let nameText: UITextField = {
        let text = UITextField()
        text.placeholder = "Name..."
        text.textAlignment = .left
        text.returnKeyType = .next
        text.leftViewMode = .always
        text.autocorrectionType = .no
        text.layer.masksToBounds = true
        text.layer.cornerRadius = Constants.cornerRadius
        text.backgroundColor = .secondarySystemBackground
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.secondaryLabel.cgColor
        return text
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: UIControl.State.normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(UIColor.label, for: UIControl.State.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(descriptionLabel)
        view.addSubview(nameText)
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextClicked), for: UIControl.Event.touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        descriptionLabel.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.18 - 50/2, width: widht * 0.8, height: 50)
        nameText.frame = CGRect(x: widht * 0.5 - widht * 0.45, y: height * 0.25, width: widht * 0.9 , height: height * 0.055)
        nextButton.frame = CGRect(x: widht * 0.5 - widht * 0.45, y: height * 0.32, width: widht * 0.9, height: height * 0.055)
        
    }
    
    @objc func nextClicked() {
        guard let name = nameText.text, !name.isEmpty, name.count >= 2  else {
            self.makeAlert(tittleInput: "Error", messageInput: "Please enter your full name")
            return
        }
        let userInfo = userSingleton.sharedInstance
        userInfo.name = nameText.text!
        
        let vc = InfoVC()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC ,animated: true)
    }
    
    //MAKE ALERT
    func makeAlert(tittleInput: String , messageInput: String){
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }


}

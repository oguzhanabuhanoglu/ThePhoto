//
//  InfoVC.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 25.02.2024.
//

import UIKit

class InfoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    struct Constants {
        static let cornerRadius : CGFloat = 8.0
    }
    
    var userInfo = userSingleton.sharedInstance
    
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "We are preparing your profile"
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.font = UIFont(name: "Helvetica", size: 22)
        return label
    }()
    
    private let profilePhoto : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .secondaryLabel
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    

    let usernameText: UITextField = {
        let text = UITextField()
        text.placeholder = " Username..."
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
    
    let bioText: UITextField = {
        let text = UITextField()
        text.placeholder = " Biografi..."
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
        title = "Create User"
        view.addSubview(descriptionLabel)
        view.addSubview(profilePhoto)
        view.addSubview(usernameText)
        view.addSubview(bioText)
        view.addSubview(nextButton)
        let tap = UITapGestureRecognizer(target: self, action: #selector(toPickImage))
        profilePhoto.addGestureRecognizer(tap)
        userInfo.profileImage = UIImage(systemName: "person.circle")!
        nextButton.addTarget(self, action: #selector(nextClicked), for: UIControl.Event.touchUpInside)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        let size = widht / 3
        
        descriptionLabel.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.18 - 50/2, width: widht * 0.8, height: 50)
        
        profilePhoto.frame = CGRect(x: widht / 2 - (size / 2) , y: height * 0.22, width: size, height: size)
        profilePhoto.layer.cornerRadius = size / 2
        
        usernameText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.40, width: widht * 0.9 , height: height * 0.055)
        bioText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.47, width: widht * 0.9 , height: height * 0.055)
        nextButton.frame = CGRect(x: widht * 0.5 - widht * 0.45, y: height * 0.54, width: widht * 0.9, height: height * 0.055)
        
        
    }
    
    @objc func toPickImage() {
        let sheet = UIAlertController(title: "Profile Picture", message: "Make easier to friends find you.", preferredStyle: UIAlertController.Style.actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Choose a photo", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        present(sheet, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profilePhoto.image = image
        userInfo.profileImage = image
    }
    
    @objc func nextClicked() {
        guard let username = usernameText.text, !username.isEmpty, username.count >= 2,
              let biografi = bioText.text, biografi.count <= 25 else {
            
            self.makeAlert(tittleInput: "It is necessary to enter the username", messageInput: "Please enter your username")
            return
        }

        userInfo.username = username
        userInfo.bio = biografi
        
        let vc = SignUpViewController()
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

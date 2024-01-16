//
//  SignUpViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    struct Constants {
        static let cornerRadius : CGFloat = 8.0
    }
    
    //SUBVİEWS------------------------------------------------------------------------------
    private let profilePhoto : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .secondaryLabel
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let usernameText : UITextField = {
        let textField = UITextField()
        textField.placeholder = " Username"
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        return textField
    }()
    
    private let emailText : UITextField = {
        let textField = UITextField()
        textField.placeholder = " Email"
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        return textField
    }()
    
    private let passwordText : UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = " Password"
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        return textField
    }()
    
    private let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: UIControl.State.normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.title = "Create New Account"
        
        addSubviews()
        addImageGesture()
        
        usernameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
    
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: UIControl.Event.touchUpInside)
    
    }
    
    private func addSubviews(){
        view.addSubview(profilePhoto)
        view.addSubview(usernameText)
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(signUpButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        let size = widht / 3
        profilePhoto.frame = CGRect(x: widht / 2 - (size / 2) , y: height * 0.085, width: size, height: size)
        profilePhoto.layer.cornerRadius = size / 2
        
        usernameText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.3, width: widht * 0.9 , height: height * 0.055)
        emailText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.37, width: widht * 0.9 , height: height * 0.055)
        passwordText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.44, width: widht * 0.9 , height: height * 0.055)
        signUpButton.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.53, width: widht * 0.9 , height: height * 0.055)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: UIControl.Event.touchUpInside)
    }
    
    
    //IMAGE PİCKER STUFF---------------------------------------------------------------------
    private func addImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePhoto.addGestureRecognizer(tap)
    }
    
    @objc func didTapImage() {
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
    }
    
    //ACTİONS--------------------------------------------------------------------------------
    @objc private func didTapSignUpButton() {
        
        usernameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        
        guard let username = usernameText.text, !username.isEmpty, username.count >= 2,
           let email = emailText.text,
           let password = passwordText.text else {
            return
        }
        let data = profilePhoto.image?.pngData()
        //create user with authmanager
        
        AuthManager.shared.signUp(username: username, email: email, password: password, profilePicture: data) { result in
            
            DispatchQueue.main.async {
                switch result {
                case.success(let user):
                    
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    UserDefaults.standard.setValue(user.username, forKey: "username")
                    
                    let tabBar = TabBarViewController()
                    tabBar.modalPresentationStyle = .fullScreen
                    tabBar.selectedIndex = 2
                    self.present(tabBar, animated: true)
                    
                case.failure(let error):
                    self.makeAlert(tittleInput: "Error!", messageInput: error.localizedDescription ?? "error")
                }
            }
        }
    }
    
    //MAKE ALERT
    func makeAlert(tittleInput: String , messageInput: String){
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
 
     
    }




//TEXTFİELD DELEGATES------------------------------------------------------------------------------
extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameText {
            emailText.becomeFirstResponder()
        }else if textField == emailText {
            passwordText.becomeFirstResponder()
        }else{
            didTapSignUpButton()
        }
        
        return true
    }
}


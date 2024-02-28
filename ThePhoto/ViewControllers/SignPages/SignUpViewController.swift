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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Here we go!"
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.font = UIFont(name: "Helvetica", size: 25)
        return label
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
        
        emailText.delegate = self
        passwordText.delegate = self
    
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: UIControl.Event.touchUpInside)
    
    }
    
    private func addSubviews(){
        view.addSubview(descriptionLabel)
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(signUpButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        let size = widht / 3
       
        descriptionLabel.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.18 - 50/2, width: widht * 0.8, height: 50)
        emailText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.23, width: widht * 0.9 , height: height * 0.055)
        passwordText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.30, width: widht * 0.9 , height: height * 0.055)
        signUpButton.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.38, width: widht * 0.9 , height: height * 0.055)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: UIControl.Event.touchUpInside)
    }
    
    
    //IMAGE PİCKER STUFF---------------------------------------------------------------------
    
   
    

    
    //ACTİONS--------------------------------------------------------------------------------
    @objc private func didTapSignUpButton() {
        
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        
        var userInfo = userSingleton.sharedInstance
        let userInfos = UserInfo(username: userInfo.username, name: userInfo.name, bio: userInfo.bio, score: 0)
        
        
        guard let email = emailText.text,
              let password = passwordText.text else {
            return
        }
        let username = userInfos.username
        
        if let data = userInfo.profileImage.pngData(){
            //create account
            AuthManager.shared.signUp(username: username, email: email, password: password, profilePicture: data) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case.success(let user):
                        
                        
                        UserDefaults.standard.setValue(user.email, forKey: "email")
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        
                        let newInfo = userInfos
                        DatabaseManager.shared.setUserInfo(userInfo: newInfo) {  success in
                            DispatchQueue.main.async {
                                if success {
                                    let tabBar = TabBarViewController()
                                    tabBar.modalPresentationStyle = .fullScreen
                                    tabBar.selectedIndex = 2
                                    self.present(tabBar, animated: true)
                                }
                            }
                        }
                        
                    case.failure(let error):
                        self.makeAlert(tittleInput: "Error!", messageInput: error.localizedDescription ?? "error")
                    }
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
        if textField == emailText {
            passwordText.becomeFirstResponder()
        }else if textField == passwordText {
            didTapSignUpButton()
        }
        return true
    }
}


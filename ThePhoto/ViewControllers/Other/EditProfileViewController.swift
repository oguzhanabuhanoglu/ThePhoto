//
//  EditProfileViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit

struct EditProfileFormModel {
    let label : String
    let placeholder : String
    var value : String?
}

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //to see the updated results automaticly? used in didTapSave
    public var completion: (() -> Void)?
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        return tableView
    }()
    
    var name: String = ""
    var username: String = ""
    var bio: String = ""
    
    var newname: String = ""
    var newusername: String = ""
    var newbio: String = ""
    
    private var models = [[EditProfileFormModel]]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapSave))
       
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeaderView()
        
        
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.getUserInfo(username: username) { [weak self] info in
            DispatchQueue.main.async {
                if let info = info {
                    self!.name = info.name
                    self!.username = info.username
                    self!.bio = info.bio ?? ""
                    
                    self?.configureModel()
                    self?.tableView.reloadData()
                    
                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose(){
        self.dismiss(animated: true)
    }
    
    @objc func didTapSave(){
        
        let newInfo = UserInfo(username: newname, name: newusername, bio: newbio, score: nil)
        DatabaseManager.shared.setUserInfo(userInfo: newInfo) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.didTapClose()
                    self?.completion?()
                }
            }    
        }
    }
    
    @objc func didTapProfilePhotoButton() {
        
    }
    
    private func createTableHeaderView() -> UIView {
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: widht , height: height / 4).integral)
        
        let size = header.frame.height / 1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (widht - size) / 2, y: (header.frame.height - size) / 2, width: size, height: size))
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        profilePhotoButton.layer.cornerRadius = size / 2
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: UIControl.State.normal)
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: UIControl.Event.touchUpInside)
        header.addSubview(profilePhotoButton)
        return header
    }
    
    private func configureModel(){
        //name, username, bio
        let section1label = ["Name","Username","Bio"]
        let section1Texts = [self.name, self.username, self.bio]
        print(section1Texts)
        var section1 = [EditProfileFormModel]()
        
        for (index, label) in section1label.enumerated() {
            var value = "" // Default value
            if index < section1Texts.count {
                value = section1Texts[index]
            }
            
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: value)
            section1.append(model)
        }

        //email, phonenumber, gender
        let section2label = ["Email","Phone","Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2label {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section2.append(model)
        }
        
        models.append(section1)
        models.append(section2)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 0 else{
            return nil
        }
        return "Private Infromation"
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier, for: indexPath) as! EditProfileTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    
    
}


extension EditProfileViewController : EditProfileTableViewCellDelegate {
    func editProfileTableVİewCell(_ cell: EditProfileTableViewCell, didupdateField updatedModel: EditProfileFormModel) {
        //update the model
        self.newname = updatedModel.value ?? self.name
        self.newusername = updatedModel.value ?? self.username
        self.newbio = updatedModel.value ?? self.bio
        print(updatedModel.value ?? "nil")
    }
}



//
//  EditProfileViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 7.01.2024.
//

import UIKit

struct EditProfileFormModel {
    let label : String
    let placeholdet : String
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
        
        configureModel()
        
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.getUserInfo(username: username) { [weak self] info in
            if let info = info {
                
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
        //let name = models.
        let newInfo = UserInfo(username: "", name: "", bio: "", score: nil)
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
        var section1 = [EditProfileFormModel]()
        for label in section1label {
            let model = EditProfileFormModel(label: label, placeholdet: "Enter \(label)...", value: nil)
            section1.append(model)
        }
        //email, phonenumber, gender
        let section2label = ["Email","Phone","Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2label {
            let model = EditProfileFormModel(label: label, placeholdet: "Enter \(label)...", value: nil)
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
        print(updatedModel.value ?? "nil")
    }
}



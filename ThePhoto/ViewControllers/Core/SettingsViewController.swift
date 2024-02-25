//
//  SettingsViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit
import SafariServices

struct SettingsCellModel {
    let title : String
    let handler : (() -> Void)
}

final class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingsCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureModels()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func configureModels() {
       
        data.append([
            SettingsCellModel(title: "Edit Profile"){ [weak self] in
                self?.didTapEditProfile()
            },
            
            SettingsCellModel(title: "Invite Friends"){ [weak self] in
                self?.didTapInviteFriends()
            },
            
            SettingsCellModel(title: "Notifications"){ [weak self] in
                self?.didTapNotifications()
            }
            
        ])
        
        data.append([
            SettingsCellModel(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .Privacy)
            },
            
            SettingsCellModel(title: "Terms Of Service") { [weak self] in
                self?.openURL(type: .Terms)
            },
            
            SettingsCellModel(title: "Help & Feedback") { [weak self] in
                self?.openURL(type: .Help)
            }
        ])
        
        data.append([
            SettingsCellModel(title: "Log Out")  { [weak self] in
            self?.didTapLogOutButton()
            }
        ])
            
    }
    
    private enum SettingsUrlType{
        case Terms, Privacy, Help
    }
    
    private func openURL(type: SettingsUrlType){
        var urlString : String = ""
        switch type {
        case .Terms: urlString = ""
        case .Privacy: urlString = ""
        case .Help: urlString = ""
        }
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapEditProfile(){
        let vc = EditProfileViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC ,animated: true)
    }
    
    private func didTapInviteFriends(){
        
    }
    
    private func didTapNotifications(){
        
    }
    
    private func didTapLogOutButton() {
        
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: UIAlertAction.Style.destructive, handler: { _ in
            AuthManager.shared.signOut { success in
                DispatchQueue.main.async {
                    if success{
                        //present login
                        let vc = SignInViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }else{
                        //error
                        fatalError("Could not log out user")
                    }
                }
            }
        }))
        
        present(actionSheet, animated: true)
        //for ipads
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data[indexPath.section][indexPath.row].handler()
    }
    
    


}

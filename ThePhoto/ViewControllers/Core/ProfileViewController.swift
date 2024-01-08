//
//  ProfileViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ananan"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapSettingsButton))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    

    @objc func didTapSettingsButton(){
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    

}

//
//  TabBarViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .label
        
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
            let currentUser = User(username: username, email: email)
        
        
        //DEFİNE VCS
        let search = ExploreViewController()
        let feed = FeedViewController()
        let profile = ProfileViewController(user: currentUser)
       // let profile = ProfileViewController()
       
    
        let nav1 = UINavigationController(rootViewController: search)
        let nav2 = UINavigationController(rootViewController: feed)
        let nav3 = UINavigationController(rootViewController: profile)
        
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label

        
        //DEFİNE TAB İTEMS
        nav1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 1)
        
        
        

        self.setViewControllers([nav1, nav2, nav3], animated: false)
        
        
    }
    

}

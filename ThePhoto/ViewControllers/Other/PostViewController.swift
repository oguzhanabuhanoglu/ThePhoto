//
//  PostViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 8.01.2024.
//

import UIKit

class PostViewController: UIViewController {

    private let post: Post
    
   
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "post"
        view.backgroundColor = .systemBackground
        
        
    }
    



}

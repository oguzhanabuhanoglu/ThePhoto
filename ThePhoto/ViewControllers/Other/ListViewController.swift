//
//  ListViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class ListViewController: UIViewController {
    
    private var viewModels: [ListUserCellViewModel] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()
    
    // Mark - Init
    enum ListType {
        case friends(user: User)
        case likers(user: User)
        
        var title: String{
            switch self {
            case .friends:
                return "Friends"
            case .likers:
                return "Likers"
            }
        }
    }
    
    let type: ListType
    
    init(type: ListType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        //tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        title = type.title
        
        
        configureViewModels()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func configureViewModels(){
        switch type {
        case .friends(let user):
            DatabaseManager.shared.getFriends(for: user.username) { [weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserCellViewModel(imageUrl: nil, username: $0, name: nil)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        case .likers(let user):
            break
        }
    }
    

    

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        let username = viewModels[indexPath.row].username
        
        DatabaseManager.shared.findUserWUsername(with: username) { user in
            if let user = user {
                DispatchQueue.main.async {
                    let vc = ProfileViewController(user: user)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.065
    }
    
    
}

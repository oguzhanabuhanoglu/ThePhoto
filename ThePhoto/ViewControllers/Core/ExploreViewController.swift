//
//  SearchViewController.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import UIKit

class ExploreViewController: UIViewController, UISearchResultsUpdating {
   
    private let searchVC = UISearchController(searchResultsController: SearchResultViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        searchVC.searchBar.placeholder = "Search..."
        
        //this is some kind of delegate for search bar
        searchVC.searchResultsUpdater = self
        (searchVC.searchResultsController as? SearchResultViewController)?.delegate = self
        navigationItem.searchController = searchVC
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultViewController,
              let query = searchController.searchBar.text else {
            return
        }
        //find user codes from database manager
        DatabaseManager.shared.searchByUsername(with: query) { results in
            DispatchQueue.main.async {
                resultsVC.update(with: results)
            }
        }
    }
    
}

extension ExploreViewController: SearchResultViewControllerDelegate {
    func searchResultViewController(_ vc: SearchResultViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

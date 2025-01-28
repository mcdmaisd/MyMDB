//
//  SearchViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

class SearchViewController: BaseViewController {
    private let tableView = UITableView()
    
    var movieTitle: String?
    var keyword: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self, C.searchMovieTitle)
        configureLeftBarButtonItem(self)
        initSearchBar(movieTitle)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        keyword?(text)
    }
    
    private func initSearchBar(_ title: String?) {
        let searchController = UISearchController(searchResultsController: nil)
        let searchbar = searchController.searchBar
        
        searchbar.delegate = self
        searchbar.placeholder = C.searchBarPlaceHolder
        searchbar.text = title
        searchbar.searchTextField.backgroundColor = .gray
        
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

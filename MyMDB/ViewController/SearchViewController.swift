//
//  SearchViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-27.
//

import UIKit

final class SearchViewController: BaseViewController {
    private let tableView = UITableView()
    private let emptyLabel = HeaderLabel()
        
    var viewModel = SearchViewModel()
        
    override func configureHierarchy() {
        addSubView(tableView)
        addSubView(emptyLabel)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        emptyLabel.isHidden = true
        emptyLabel.sizeToFit()
        emptyLabel.configureData(C.emptySearchResult)
        configureTableView(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationTitle(self, C.searchMovieTitle)
        configureLeftBarButtonItem(self)
        initTableView()
        initSearchBar()
        binding()
    }
    
    private func binding() {
        viewModel.output.searchResult.lazyBind { [weak self] list in
            self?.applyResult(list.isEmpty)
        }
        
        viewModel.output.scrollToTop.lazyBind { [weak self] result in
            if result {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        
        viewModel.output.index.bind { [weak self] index in
            guard let index else { return }
            UIView.performWithoutAnimation {
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
        
    private func applyResult(_ empty: Bool) {
        emptyLabel.isHidden = !empty
        tableView.isHidden = empty
        tableView.reloadData()
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UIApplication.shared.getCurrentScene().bounds.width / 2
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchButton.value = searchBar.text
    }
    
    private func initSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        let searchbar = searchController.searchBar
        
        viewModel.output.title.bind { title in
            searchbar.text = title
        }
        searchbar.delegate = self
        searchbar.placeholder = C.searchBarPlaceHolder
        searchbar.searchTextField.backgroundColor = .gray
        
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.searchResultCount.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as! SearchResultTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.configureData(viewModel.output.searchResult.value[row], viewModel.output.title.value ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToDetailVC(self, viewModel.output.searchResult.value[indexPath.row])
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.input.pagination.value = indexPaths
    }
}

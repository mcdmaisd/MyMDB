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
    
    private var page = AC.firstPage
    private var isNotFinished = false
    
    var totalPage: Int?
    var movieTitle: String?
    var keyword: ((String) -> Void)?
    var searchResults: [Results] = [] {
        didSet {
            applyResult(searchResults.isEmpty)
        }
    }
    
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
        emptyLabel.configureLabel(C.emptySearchResult)
        configureTableView(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationTitle(self, C.searchMovieTitle)
        configureLeftBarButtonItem(self)
        initSearchBar(movieTitle)
        initTableView()
        NotificationCenter
            .default
            .addObserver(self, selector:#selector(reloadButton), name: .name, object: nil)
    }
    
    @objc
    private func reloadButton(_ notification: Notification) {
        if let data = notification.object as? Int {
            for (i, movie) in searchResults.enumerated() {
                if movie.id == data {
                    UIView.performWithoutAnimation {
                        tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                    }
                    break
                }
            }
        }
    }
    
    private func applyResult(_ empty: Bool) {
        emptyLabel.isHidden = !empty
        
        tableView.isHidden = empty
        tableView.reloadData()
        
        if totalPage == nil && !searchResults.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UIScreen.main.bounds.width / 2
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
    }
    
    private func search(_ keyword: String, completionHandler: @escaping () -> Void) {
        let request = APIRouter.search(keyword: keyword, page: page)
        
        APIManager.shared.requestAPI(request, self) { [self] (data: Movies) in
            let result = data.results.filter { $0.genre_ids != nil }
            
            if page == 1 {
                searchResults = result
            } else {
                searchResults.append(contentsOf: result)
            }

            if totalPage == nil { totalPage = data.total_pages }

            completionHandler()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if text.isEmpty {
            presentAlert("", C.emptyMessage)
            return
        }
        
        keyword?(text)
        
        if movieTitle == text { return }
        
        movieTitle = text
        totalPage = nil
        page = AC.firstPage
        
        search(text) { }
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as! SearchResultTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.configureData(searchResults[row], movieTitle ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToDetailVC(self, searchResults[indexPath.row])
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let totalPage else { return }
        if isNotFinished { return }
        
        for indexPath in indexPaths {
            if indexPath.row >= searchResults.count - 6 && !isNotFinished {
                if page > totalPage { return }
                isNotFinished = true

                search(movieTitle ?? "") { [self] in
                    if page <= totalPage {
                        page += 1
                    }
                    
                    isNotFinished = false
                }
            }
        }
    }
}

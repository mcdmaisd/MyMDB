//
//  SearchViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-11.
//

import Foundation

class SearchViewModel: BaseViewModel {
    var input: Input
    var output: Output
    var keyword: ((String?) -> Void)?
    
    private var currentPage = AC.firstPage
    private var totalPages: Int?
    private var isNotFinished = false

    struct Input {
        let title: Observable<String?> = .init(nil)
        let searchButton: Observable<String?> = .init(nil)
        let pagination: Observable<[IndexPath]?> = .init(nil)
    }
    
    struct Output {
        let title: Observable<String?> = .init(nil)
        let searchResult: Observable<[TMDBMovieInfo]> = .init([])
        let searchResultCount: Observable<Int> = .init(0)
        let index: Observable<Int?> = .init(nil)
        let scrollToTop = Observable(false)
    }

    init() {
        input = Input()
        output = Output()
        
        addNotification()
        
        transform()
    }
    
    func transform() {
        input.title.bind { [weak self] title in
            guard let title else { return }
            self?.searchMovie(title) { }
        }
        
        input.searchButton.lazyBind { [weak self] keyword in
            guard
                let keyword = keyword?.trimmingCharacters(in: .whitespacesAndNewlines),
                let self
            else { return }
            
            if keyword.isEmpty {
                showAlert(C.emptyMessage)
                return
            }
            
            self.keyword?(keyword)
                
            if output.title.value == keyword { return }

            output.title.value = keyword
            totalPages = nil
            currentPage = AC.firstPage
            searchMovie(keyword) { }
        }
        
        input.pagination.lazyBind { [weak self] indexPaths in
            guard
                let indexPaths,
                let self
            else { return }
            
            pagination(indexPaths)
        }
    }
    
    private func addNotification() {
        NotificationCenter
            .default
            .addObserver(self, selector:#selector(reloadButton), name: .name, object: nil)
    }
    
    @objc
    private func reloadButton(_ notification: Notification) {
        if let data = notification.object as? Int {
            for (i, movie) in output.searchResult.value.enumerated() {
                if movie.id == data {
                    output.index.value = i
                    break
                }
            }
        }
    }

    private func searchMovie(_ title: String, _ completionHandler: @escaping () -> Void) {
        let request = APIRouter.search(keyword: title, page: currentPage)
        
        APIManager.shared.requestAPI(request) { [weak self] (data: TMDBSearchAndTrendingResponse) in
            guard let self else { return }
            
            let result = data.results.filter { $0.genre_ids != nil }

            if currentPage == 1 {
                output.searchResultCount.value = result.count
                output.searchResult.value = result
                
                DispatchQueue.main.async { [weak self] in
                    self?.output.scrollToTop.value = true
                }
            } else {
                output.searchResultCount.value += result.count
                output.searchResult.value.append(contentsOf: result)
            }
            
            output.title.value = title

            if totalPages == nil {
                totalPages = data.total_pages
            }

            completionHandler()
        }
    }
    
    private func pagination(_ indexPaths: [IndexPath]) {
        if isNotFinished { return }
        guard let totalPages else { return }
        
        for indexPath in indexPaths {
            if indexPath.row >= output.searchResult.value.count - 6 && !isNotFinished {
                if currentPage > totalPages { return }
                isNotFinished = true

                searchMovie(output.title.value ?? "") { [weak self] in
                    guard let self else { return }
                    
                    if currentPage <= totalPages {
                        currentPage += 1
                    }
                    
                    isNotFinished = false
                }
            }
        }
    }
}

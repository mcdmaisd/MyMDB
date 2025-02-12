//
//  MainViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-11.
//

import Foundation

class MainViewModel: BaseViewModel {
    var input: Input
    var output: Output

    struct Input {
        let keyword: Observable<String?> = .init(nil)
        let keywordIndex: Observable<Int?> = .init(nil)
        let removeButton: Observable<Int?> = .init(nil)
        let removeAllButton: Observable<Void?> = .init(nil)
    }
    
    struct Output {
        let searchHistory = Observable(U.shared.get(C.searchHistoryKey, [String]()))
        let movies: Observable<[TMDBMovieInfo]> = .init([])
        let movieCount = Observable(0)
        let index: Observable<Int?> = .init(nil)
    }

    init() {
        input = Input()
        output = Output()
        
        addNotification()
        getTrending()
        
        transform()
    }
    
    func transform() {
        input.keyword.lazyBind { [weak self] word in
            guard let word else { return }
            self?.insertWord(word)
        }
        
        input.keywordIndex.lazyBind { [weak self] index in
            guard
                let index,
                let self
            else { return }
            
            let keyword = output.searchHistory.value[index]
            insertWord(keyword)
        }
        
        input.removeButton.lazyBind { [weak self] index in
            guard let index else { return }
            self?.output.searchHistory.value.remove(at: index)
        }
        
        input.removeAllButton.lazyBind { [weak self] _ in
            self?.output.searchHistory.value.removeAll()
        }
    }
    
    private func addNotification() {
        NotificationCenter
            .default
            .addObserver(self, selector:#selector(reloadButton), name: .name, object: nil)
    }
    
    private func insertWord(_ keyword: String) {
        var keywords = output.searchHistory.value
        let result = keywords.filter { $0.localizedCaseInsensitiveCompare(keyword) == .orderedSame }
        let data = result.isEmpty ? keyword : result.first!

        if let index = keywords.firstIndex(of: data) {
            keywords.remove(at: index)
        }
        keywords.insert(data, at: 0)
        
        output.searchHistory.value = keywords
        U.shared.set(keywords, C.searchHistoryKey)
    }
    
    private func getTrending() {
        APIManager.shared.requestAPI(APIRouter.trending) { [weak self] (data: TMDBSearchAndTrendingResponse) in
            self?.output.movies.value = data.results
            self?.output.movieCount.value = data.results.count
        }
    }
    
    @objc
    private func reloadButton(_ notification: Notification) {
        if let data = notification.object as? Int {
            for (i, movie) in output.movies.value.enumerated() {
                if movie.id == data {
                    output.index.value = i
                    break
                }
            }
        }
    }
}

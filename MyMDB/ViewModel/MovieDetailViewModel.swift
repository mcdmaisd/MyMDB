//
//  MovieDetailViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-12.
//

import Foundation

class MovieDetailViewModel {
    var input: Input
    var output: Output

    private(set) var castAndPoster: [[Any]] = [[], []]

    struct Input {
        let movieInfo: Observable<TMDBMovieInfo?> = .init(nil)
        let moreButton: Observable<String?> = .init(nil)
    }
    
    struct Output {
        let heightDivider: Observable<Double> = .init(0)
        let movieInfo: Observable<TMDBMovieInfo?> = .init(nil)
        let numberOfLines: Observable<Int> = .init(0)
        let buttonTitle: Observable<String> = .init("")
        let backdrops: Observable<[TMDBImageInfo]> = .init([])
        let convertedInfo = Observable([String]())
        let layoutUpdate: Observable<Void> = .init(())
        let pages: Observable<Int> = .init(0)
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }
    
    func transform() {
        input.movieInfo.bind { [weak self] info in
            guard
                let info,
                let self
            else { return }
            
            output.movieInfo.value = info
            makeGenre(info)
            makeImage(info)
        }
        
        input.moreButton.bind { [weak self] title in
            guard
                let self,
                let title
            else { return }
            
            var text = title
            if text == C.more {
                text = C.hide
                output.numberOfLines.value = 0
            } else {
                text = C.more
                output.numberOfLines.value = 3
            }
            
            output.buttonTitle.value = text
        }
    }
    
    private func makeGenre(_ info: TMDBMovieInfo) {
        let genres = info.genre_ids?.map { AC.genreDictionary[$0] }.prefix(2).compactMap { $0 }.joined(separator: AC.comma) ?? ""
        let movieData = [
            info.release_date ?? "",
            String(format: "%.1f", info.vote_average ?? 0.0),
            genres
        ]
        
        output.convertedInfo.value = movieData
    }
    
    private func makeImage(_ result: TMDBMovieInfo) {
        let imageRequest = APIRouter.image(id: result.id)
        let creditRequest = APIRouter.credit(id: result.id)
        let group = DispatchGroup()
        
        group.enter()
        APIManager.shared.requestAPI(imageRequest) { [weak self] (data: TMDBImageResponse) in
            guard let self else { return }
            let result = Array(data.backdrops.prefix(5))
            castAndPoster[1] = data.posters
            output.backdrops.value = result
            output.heightDivider.value = result.first?.aspect_ratio ?? 1
            output.pages.value = result.count
            group.leave()
        }
        
        group.enter()
        APIManager.shared.requestAPI(creditRequest) { [weak self] (data: TMDBCreditResponse) in
            self?.castAndPoster[0] = data.cast
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.output.layoutUpdate.value = ()
        }
    }
    
    
    
    
}

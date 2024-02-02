//
//  DetailViewModel.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 2.02.2024.
//

import Foundation
import Combine

protocol DetailViewModelLogic: AnyObject {
    func getSectionType(at section: Int) -> DetailViewModel.CellTypes
    func getSectionCount() -> Int
    func getRowCount() -> Int
    func getAllData() -> MovieDetailResponseModel?
    func getCellData(type: DetailViewModel.CellTypes) -> Any
    func transform(input: AnyPublisher<DetailViewModel.Input, Never>) -> AnyPublisher<DetailViewModel.Output, Never>
}

final class DetailViewModel: DetailViewModelLogic {
    enum Input {
        case fetchMovie
        case didPressImdbButton
    }
    
    enum Output {
        case displayLoading(isOn: Bool)
        case displayData
    }
    
    enum CellTypes: CaseIterable {
        case imageAndTitle
        case overview
        case genre
        case vote
        case releaseDate
        case imdbButton
    }
    
    private var movieDetail: MovieDetailResponseModel?
    private let movieCases: MovieUseCaseTypes
    private let router: DetailViewRoutingLogic
    private let id: String
    
    private var sections: [CellTypes] = CellTypes.allCases
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
        
    init(useCases: MovieUseCaseTypes,
         router: DetailViewRoutingLogic,
         id: String) {
        self.router = router
        self.movieCases = useCases
        self.id = id
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.sink { [weak self] event in
            guard let self = self
            else { return }
            
            switch event {
            case .fetchMovie:
                self.handleGetMovieDetail()
                
            case .didPressImdbButton:
                guard let id = self.movieDetail?.imdbId
                else { return }
                
                self.router.routeToIMDB(imdbId: id)
                
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getSectionType(at section: Int) -> CellTypes {
        return sections[section]
    }
    
    func getSectionCount() -> Int {
        return (movieDetail == nil) ? 0 : sections.count
    }
    
    func getRowCount() -> Int {
        return 1
    }
    
    func getAllData() -> MovieDetailResponseModel? {
        return movieDetail
    }
    
    func getCellData(type: CellTypes) -> Any {
        switch type {
        case .imageAndTitle:
            let model:ImageTableViewCellDataModel = .init(imagePath: movieDetail?.backdropPath,
                                                             title: movieDetail?.originalTitle)
            return model
            
        case .overview:
            let model: InformationTableViewCellDataModel = .init(text: movieDetail?.overview)
            return model
            
        case .genre:
            var genres: String = ""
            movieDetail?.genres?.forEach({  genres += ($0.name ?? "") + " "  })
            let model: InformationTableViewCellDataModel = .init(text: genres)
            return model
            
        case .vote:
            let vote: String = "Vote : " + String(format: "%.2f", movieDetail?.voteAverage ?? 0)
            let model: InformationTableViewCellDataModel = .init(text: vote)
            return model
            
        case .releaseDate:
            let date: String = "Release Date : " + (movieDetail?.releaseDate ?? "-")
            let model: InformationTableViewCellDataModel = .init(text: date)
            return model
            
        case .imdbButton:
            let model: ButtonTableViewCellDataModel = .init(text: "Visit IMDB Page")
            return model
            
        }
        
    }
    
    private func handleGetMovieDetail() {
        output.send(.displayLoading(isOn: true))
        movieCases.movieDetail(with: id).sink { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let success):
                self.movieDetail = success
                self.output.send(.displayData)
                
            case .failure(let error):
                self.router.routeToAlert(alertMessage: error.description)
            }
            
            self.output.send(.displayLoading(isOn: false))
        }.store(in: &cancellables)

    }
    
}

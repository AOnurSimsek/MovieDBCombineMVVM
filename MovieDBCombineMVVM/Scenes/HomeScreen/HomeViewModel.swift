//
//  HomeViewModel.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 1.02.2024.
//

import UIKit.UIViewController
import Combine

protocol HomeViewModelLogic: AnyObject {
    func getDataCount() -> Int
    func getData(at index: Int) -> MovieResultResponseModel
    func transform(input: AnyPublisher<HomeViewModel.Input, Never>) -> AnyPublisher<HomeViewModel.Output, Never>
}

final class HomeViewModel: HomeViewModelLogic {
    enum Input {
        case fetchMovies
        case fetchMoreMovies
        case searchMovies(searchText: String)
        case searchMoreMovies(searchText: String)
        case didSelectData(at: Int)
        case didPressOccurrenceButton(title: String)
    }
    
    enum Output {
        case displayLoading(isOn: Bool)
        case displayData
    }
    
    private var movies: [MovieResultResponseModel] = []
    private let movieCases: MovieUseCaseTypes
    private let searchCases: SearchUseCaseTypes
    private let router: HomeViewRoutingLogic
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var requestCancellables = Set<AnyCancellable>()
    
    private var pageNumber: Int = 1
    private var isLoadingMore: Bool = false
    private var canLoadMore: Bool = true
    
    init(useCases: MovieUseCaseTypes,
         searchCases: SearchUseCaseTypes,
         router: HomeViewRoutingLogic) {
        self.router = router
        self.movieCases = useCases
        self.searchCases = searchCases
    }
    
    func getDataCount() -> Int {
        return movies.count
    }
    
    func getData(at index: Int) -> MovieResultResponseModel {
        return movies[index]
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.sink { [weak self] event in
            guard let self = self
            else { return }
            
            switch event {
            case .fetchMovies:
                self.handleGetMovies()
                
            case .fetchMoreMovies:
                let requestedPageNumber = self.pageNumber + 1
                self.handleGetMovies(pageNumber: requestedPageNumber)
                
            case .searchMovies(let searchText):
                handleSearchMovies(searchText: searchText)
                
            case .searchMoreMovies(let searchText):
                let requestedPageNumber = self.pageNumber + 1
                self.handleSearchMovies(searchText: searchText,
                                        pageNumber: requestedPageNumber)
                
            case .didSelectData(let index):
                guard let id = self.getData(at: index).id
                else { return }
                
                self.router.routeToDetail(id: id)
                
            case .didPressOccurrenceButton(let title):
                self.router.routeToOccurence(title: title)
                
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func handleGetMovies(pageNumber: Int = 1) {
        guard !isLoadingMore,
              canLoadMore
        else { return }
        
        requestCancellables.forEach { $0.cancel() }
        requestCancellables.removeAll()
        
        self.isLoadingMore = true
        output.send(.displayLoading(isOn: true))
        movieCases.topRatedMovies(with: pageNumber).sink { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let success):
                self.canLoadMore = (success.totalPages ?? -1) > pageNumber
                self.isLoadingMore = false
                
                self.pageNumber = pageNumber
                
                if pageNumber == 1 {
                    self.movies = success.results ?? []
                } else {
                    self.movies.append(contentsOf: success.results ?? [])
                }
                
                self.output.send(.displayData)
                
            case .failure(let error):
                self.router.routeToAlert(alertMessage: error.description)
            }
            
            self.output.send(.displayLoading(isOn: false))
        }.store(in: &requestCancellables)

    }
    
    private func handleSearchMovies(searchText: String,
                                    pageNumber: Int = 1) {
        guard !isLoadingMore,
              canLoadMore
        else { return }
        
        requestCancellables.forEach { $0.cancel() }
        requestCancellables.removeAll()
        
        self.isLoadingMore = true
        output.send(.displayLoading(isOn: true))
        searchCases.searchMovie(page: pageNumber, searchText: searchText).sink { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let success):
                self.canLoadMore = (success.totalPages ?? -1) > pageNumber
                self.isLoadingMore = false
                
                self.pageNumber = pageNumber
                
                if pageNumber == 1 {
                    self.movies = success.results ?? []
                } else {
                    self.movies.append(contentsOf: success.results ?? [])
                }
                
                self.output.send(.displayData)
                
            case .failure(let error):
                self.router.routeToAlert(alertMessage: error.description)
            }
            
            self.output.send(.displayLoading(isOn: false))
        }.store(in: &requestCancellables)
        
    }
    
    
}

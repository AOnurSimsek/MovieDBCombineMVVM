//
//  SearchUseCases.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 2.02.2024.
//

import Foundation
import Combine

protocol SearchUseCaseTypes: AnyObject {
    func searchMovie(page: Int,
                     searchText: String) -> AnyPublisher<Result<MoviesResponseModel, APIError>, Never>
}

final class SearchUseCases: SearchUseCaseTypes {
    private var network: NetworkServiceType
    
    init(network: NetworkServiceType) {
        self.network = network
    }
    
    func searchMovie(page: Int,
                     searchText: String) -> AnyPublisher<Result<MoviesResponseModel, APIError>, Never> {
        return network
            .load(with: SearchEndpoint.movie(.init(query: searchText, page: page)).request,
                  responseModel: MoviesResponseModel.self)
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<MoviesResponseModel, APIError>, Never> in .just(.failure(.unknownError(error.localizedDescription))) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
}

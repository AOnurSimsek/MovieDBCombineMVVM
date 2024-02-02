//
//  MovieUseCases.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 1.02.2024.
//

import Foundation
import Combine

protocol MovieUseCaseTypes: AnyObject {
    func topRatedMovies(with page: Int) -> AnyPublisher<Result<MoviesResponseModel, APIError>, Never>
    func movieDetail(with id: String) -> AnyPublisher<Result<MovieDetailResponseModel, APIError>, Never>
}

final class MovieUseCases: MovieUseCaseTypes {
    private var network: NetworkServiceType
    
    init(network: NetworkServiceType) {
        self.network = network
    }
    
    func topRatedMovies(with page: Int) -> AnyPublisher<Result<MoviesResponseModel, APIError>, Never> {
        return network
            .load(with: MovieEndpoint.topRatedMovie(.init(page: page)).request, 
                  responseModel: MoviesResponseModel.self)
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<MoviesResponseModel, APIError>, Never> in .just(.failure(.unknownError(error.localizedDescription))) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func movieDetail(with id: String) -> AnyPublisher<Result<MovieDetailResponseModel, APIError>, Never> {
        return network
            .load(with: MovieEndpoint.movieDetail(id).request,
                  responseModel: MovieDetailResponseModel.self)
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<MovieDetailResponseModel, APIError>, Never> in .just(.failure(.unknownError(error.localizedDescription))) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
}

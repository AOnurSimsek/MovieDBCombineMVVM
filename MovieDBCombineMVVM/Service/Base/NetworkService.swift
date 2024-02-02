//
//  NetworkService.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 1.02.2024.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {
    func load<T:Decodable>(with request: URLRequest?,
                           responseModel: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkService: NetworkServiceType {
    static let shared = NetworkService()
    
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    func load<T: Decodable>(with request: URLRequest?,
                            responseModel: T.Type) -> AnyPublisher<T, Error> {
        guard let url = request?.url
        else { return .fail(APIError.invalidRequest())}
        
        return session.dataTaskPublisher(for: url)
            .mapError { _ in APIError.invalidRequest()}
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse
                else { return .fail(APIError.invalidResponse())}
                
                guard 200..<300 ~= response.statusCode
                else { return .fail(APIError.serverError()) }
                
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}

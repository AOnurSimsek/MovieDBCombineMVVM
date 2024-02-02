//
//  MovieEndpoint.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 19.01.2024.
//

import Foundation

enum MovieEndpoint: BaseEndpoint {
    case topRatedMovie(TRMovieRequestModel)
    case movieDetail(String)
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        return request
    }
    
    var path: String {
        switch self {
        case .topRatedMovie:
            return "/3/movie/top_rated"

        case .movieDetail(let movieId):
            return "/3/movie/" + movieId
            
        }
        
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = nil
        components.path = self.path
        if !self.queryItems.isEmpty{
            components.queryItems = self.queryItems
        }
        
        return components.url
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .movieDetail:
            return ApiKeyRequestModel().asQueryItems()
            
        case .topRatedMovie(let requestModel):
            var queryItems = requestModel.asQueryItems()
            let apiKeyModel = ApiKeyRequestModel().asQueryItems()
            queryItems.append(contentsOf: apiKeyModel)
            return queryItems
            
        }
        
    }
    
     var httpMethod: String {
        switch self {
        case .movieDetail,
             .topRatedMovie:
            return HTTPMethods.get.rawValue
            
        }
        
    }
    
}

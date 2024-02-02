//
//  SearchEndpoint.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 20.01.2024.
//

import Foundation

enum SearchEndpoint: BaseEndpoint {
    case movie(SearchRequestModel)
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        return request
    }
    
    var path: String {
        switch self {
        case .movie:
            return "/3/search/movie"
            
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
        case .movie(let requestModel):
            var queryItems = requestModel.asQueryItems()
            let apiKeyModel = ApiKeyRequestModel().asQueryItems()
            queryItems.append(contentsOf: apiKeyModel)
            return queryItems
            
        }
        
    }
    
     var httpMethod: String {
        switch self {
        case .movie:
            return HTTPMethods.get.rawValue
            
        }
        
    }
    
}

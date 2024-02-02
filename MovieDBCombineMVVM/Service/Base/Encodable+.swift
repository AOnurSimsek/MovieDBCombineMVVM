//
//  Encodable+.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 19.01.2024.
//

import Foundation

extension Encodable {
    func asQueryItems() -> [URLQueryItem] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { fatalError() }
        
        let queryItems = dictionary.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        return queryItems
    }
    
}

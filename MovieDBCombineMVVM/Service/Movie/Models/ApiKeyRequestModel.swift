//
//  ApiKeyRequestModel.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 19.01.2024.
//

import Foundation

struct ApiKeyRequestModel: Encodable {
    let apiKey: String = Constants.apiKey
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
    
}

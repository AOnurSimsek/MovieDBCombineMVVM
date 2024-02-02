//
//  ProductionCompanyResponseModel.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 19.01.2024.
//

import Foundation

struct ProductionCompanyResponseModel: Decodable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
}

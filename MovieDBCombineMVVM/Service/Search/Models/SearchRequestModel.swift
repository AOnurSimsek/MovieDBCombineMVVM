//
//  SearchRequestModel.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 20.01.2024.
//

import Foundation

struct SearchRequestModel: Encodable {
    let language = "en-US"
    let query: String
    let page: Int
}

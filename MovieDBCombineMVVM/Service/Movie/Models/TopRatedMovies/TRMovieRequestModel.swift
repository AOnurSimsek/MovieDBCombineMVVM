//
//  TRMovieRequestModel.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 19.01.2024.
//

import Foundation

struct TRMovieRequestModel: Encodable {
    let language: String = "en-US"
    let page: Int
    
}

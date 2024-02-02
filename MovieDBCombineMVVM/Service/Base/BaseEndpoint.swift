//
//  BaseEndpoint.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 19.01.2024.
//

import Foundation

protocol BaseEndpoint {
    var request: URLRequest? { get }
    var path: String { get }
    var url: URL? { get }
    var queryItems: [URLQueryItem] { get }
    var httpMethod: String { get }
}

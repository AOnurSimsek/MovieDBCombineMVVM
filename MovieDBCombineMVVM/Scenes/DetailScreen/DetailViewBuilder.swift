//
//  DetailViewBuilder.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 31.01.2024.
//

import UIKit

final class DetailViewBuilder {
    func createDetailScreen(movieId: String) -> UIViewController {
        let router = DetailViewRouter()
        let movieUseCase: MovieUseCases = .init(network: NetworkService.shared)
        let viewModel: DetailViewModel = .init(useCases: movieUseCase,
                                               router: router,
                                               id: movieId)
        let controller: DetailViewController = .init(vm: viewModel)
        
        router.controller = controller
        
        return controller
    }
    
}

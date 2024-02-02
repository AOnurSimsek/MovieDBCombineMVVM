//
//  HomeViewBuilder.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 31.01.2024.
//

import UIKit

final class HomeViewBuilder {
    func createHomeScreen() -> UIViewController {
        let router = HomeViewRouter()
        let movieUseCase: MovieUseCases = .init(network: NetworkService.shared)
        let searchUseCase: SearchUseCases = .init(network: NetworkService.shared)
        let viewModel: HomeViewModel = .init(useCases: movieUseCase,
                                             searchCases: searchUseCase, 
                                             router: router)
        let controller: HomeViewController = .init(vm: viewModel)
        
        router.controller = controller
        
        let navController: UINavigationController = .init(rootViewController: controller)
        
        return navController
    }
    
}

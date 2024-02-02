//
//  OccurenceViewBuilder.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 31.01.2024.
//

import UIKit

final class OccurenceViewBuilder {
    func createOccurenceScreen(with title: String) -> UIViewController {
        let viewModel: OccurenceViewModel = .init(title: title)
        let controller: OccurenceViewController = .init(vm: viewModel)
        
        return controller
    }
    
}

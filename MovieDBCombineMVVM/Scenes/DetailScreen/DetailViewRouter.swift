//
//  DetailViewRouter.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 23.01.2024.
//

import UIKit
import SafariServices

protocol DetailViewRoutingLogic: AnyObject {
    func routeToIMDB(imdbId: String)
    func routeToAlert(alertMessage: String)
}

final class DetailViewRouter: DetailViewRoutingLogic,
                              UIAlertCreator {
    weak var controller: UIViewController?

    init(controller: UIViewController? = nil) {
        self.controller = controller
    }
    
    func routeToIMDB(imdbId: String) {
        guard let url = URL(string: Constants.imdbUrl + imdbId)
        else { return }
        
        let config = SFSafariViewController.Configuration()

        let vc = SFSafariViewController(url: url, configuration: config)
        controller?.present(vc, animated: true)
    }
    
    func routeToAlert(alertMessage: String) {
        let alertVC = getSimpleAlertController(message: alertMessage)
        controller?.present(alertVC, animated: true)
    }
    
}

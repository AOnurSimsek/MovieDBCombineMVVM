//
//  UINavigationController+.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit

extension UINavigationController {
    func setNavigationBarBackBarButtonItem(image: UIImage?){
        let backButton = BackBarButtonItem(title: "",
                                           style: .plain,
                                           target: nil,
                                           action: nil)
        self.topViewController?.navigationItem.backBarButtonItem = backButton
        self.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationBar.tintColor = .tmdbLightGreen
        
        if image != nil{
            self.navigationBar.backIndicatorImage = image?.withAlignmentRectInsets(.init(top: 0,
                                                                                         left: -5,
                                                                                         bottom: 0,
                                                                                         right: 0))
            self.navigationBar.backIndicatorTransitionMaskImage = image
        }
        
    }
    
}


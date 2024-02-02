//
//  UIAlertCreator.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 31.01.2024.
//

import UIKit.UIAlertController

protocol UIAlertCreator { }

extension UIAlertCreator {
    func getSimpleAlertController(title: String = "Error", message: String) -> UIAlertController {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertContoller.addAction(UIAlertAction(title: "Ok",
                                               style: .default,
                                               handler: nil))
        return alertContoller
    }
    
}

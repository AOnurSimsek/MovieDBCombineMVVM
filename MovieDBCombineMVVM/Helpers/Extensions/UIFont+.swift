//
//  UIFont+.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 20.01.2024.
//

import UIKit.UIFont

extension UIFont{
    static func custom(name: FontBook,
                       size: CGFloat) -> UIFont{
        guard let customFont = UIFont(name: name.rawValue,
                                      size:  size)
        else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return customFont
    }
    
}

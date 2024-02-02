//
//  UIImageView+.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 21.01.2024.
//

import UIKit.UIImageView

extension UIImageView {
    func setImage(path: String?) {
        image = nil
        ImageDownloadManager.shared.loadImage(path: path) { [weak self] image  in
            guard let self = self
            else { return }
            self.image = image
        }
        
    }
    
}

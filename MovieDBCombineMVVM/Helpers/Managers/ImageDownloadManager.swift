//
//  ImageDownloadManager.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 21.01.2024.
//

import UIKit.UIImage

final class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    private let cache = NSCache<NSString, AnyObject>()
    private let urlBase: String = "https://image.tmdb.org/t/p/w500"
    
    func loadImage(path: String?,
                   completion: @escaping (UIImage) -> Void) {
        guard let imagePath = path,
              let url = URL(string: urlBase + imagePath)
        else { return }
        
        if let cachedImage = cache.object(forKey: imagePath as NSString) as? UIImage {
            completion(cachedImage)
            return
        }
                
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil
            else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            if let imageData = data,
               let image = UIImage(data: imageData) {
                self.cache.setObject(image, forKey: imagePath as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }
            
        }.resume()
        
    }
    
}

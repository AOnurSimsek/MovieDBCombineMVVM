//
//  SearchBarView.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit

protocol SearhBarViewDelegate: UISearchBarDelegate, UITextFieldDelegate { }

final class SearchBarView: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureDefaults() {
        self.backgroundImage = UIImage()
        self.tintColor = .tmdbLightGreen
        self.searchTextPositionAdjustment.horizontal = 5.0
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.tmdbLightGreen.cgColor
        self.layer.borderWidth = 1
        self.setImage(.searchIcon.withTintColor(UIColor.tmdbLightGreen),
                      for: .search,
                      state: .normal)
        self.backgroundColor = .clear
        
        self.placeholder = "Search Movies"
        
        if let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.font = .custom(name: .LatoRegular, size: 14)
            textFieldInsideSearchBar.textColor = .text
            textFieldInsideSearchBar.backgroundColor = .clear
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: "Search Movies",
                                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholder,
                                                                                             NSAttributedString.Key.font: UIFont.custom(name: .LatoRegular, size: 14)])
            
            if let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel {
                textFieldInsideSearchBarLabel.backgroundColor = .clear
            }
            
        }
        
    }
    
    func setDelegate(delegate: SearhBarViewDelegate) {
        self.delegate = delegate
            
        if #available(iOS 13.0, *) {
            self.searchTextField.delegate = delegate
        } else {
            if let textfield = self.value(forKey: "searchField") as? UITextField {
                textfield.delegate = delegate
            }
                
        }
            
    }
    
}

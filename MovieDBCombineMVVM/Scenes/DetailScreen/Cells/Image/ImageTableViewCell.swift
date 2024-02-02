//
//  ImageTableViewCell.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    private lazy var movieImageView: UIImageView = {
       let view = UIImageView()
       view.contentMode = .scaleAspectFill
       return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(name: .LatoBold, size: 18)
        label.textAlignment = .center
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
       super.init(style: style,
                  reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .tmdbDarkBlue
        self.backgroundColor = .tmdbDarkBlue
        self.selectionStyle = .none
    }
    
    private func setLayout() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(movieImageView)
        movieImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        movieImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 0.6).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func populate(with model: Any?) {
        guard let data = model as? ImageTableViewCellDataModel
        else { return }
        
        titleLabel.text = data.title
        movieImageView.setImage(path: data.imagePath)
    }
    
}




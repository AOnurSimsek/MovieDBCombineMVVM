//
//  ButtonTableViewCell.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit

final class ButtonTableViewCell: UITableViewCell {
    private lazy var centerStackView: UIStackView = {
        let view = UIStackView()
         view.axis = .horizontal
         view.spacing = 15
         view.alignment = .center
         view.distribution = .fill
         view.backgroundColor = .clear
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(name: .LatoBold, size: 16)
        label.textAlignment = .left
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.image = .arrowRight.withTintColor(.tmdbLightGreen)
        view.contentMode = .scaleAspectFit
        return view
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
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        rightImageView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(centerStackView)
        centerStackView.addArrangedSubview(infoLabel)
        centerStackView.addArrangedSubview(rightImageView)
        centerStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        centerStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        centerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        centerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func populate(with model: Any?) {
        guard let data = model as? ButtonTableViewCellDataModel
        else { return }
        
        infoLabel.text = data.text
    }
    
}


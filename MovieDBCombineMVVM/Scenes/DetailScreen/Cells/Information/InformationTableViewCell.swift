//
//  InformationTableViewCell.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit

final class InformationTableViewCell: UITableViewCell {
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(name: .LatoRegular, size: 16)
        label.textAlignment = .left
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
        self.selectionStyle = .none
    }
    
    private func setLayout() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(infoLabel)
        infoLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
    }
    
    func populate(with model: Any?) {
        guard let data = model as? InformationTableViewCellDataModel
        else { return }
        
        infoLabel.text = data.text
    }
    
}

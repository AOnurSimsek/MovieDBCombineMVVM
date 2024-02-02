//
//  MovieCollectionViewCell.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 20.01.2024.
//

import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func didPressCharacterOccurence(title: String)
}

final class MovieCollectionViewCell: UICollectionViewCell {
    private lazy var textStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .custom(name: .LatoBold, size: 16)
        label.textAlignment = .left
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var voteLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .custom(name: .LatoRegular, size: 14)
        label.textAlignment = .left
        label.textColor = .text
        return label
    }()
    
    private lazy var cellStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .horizontal
        view.spacing = 12
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var occurrenceButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("   Character Occurance   ", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.backgroundColor = .tmdbLightBlue
        button.tintColor = .tmdbLightBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .custom(name: .LatoRegular, size: 12)
        return button
    }()
    
    private lazy var seperatorView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .tmdbLightGreen
        return view
    }()
    
    private weak var delegate: MovieCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    private func setUI() {
        self.contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        occurrenceButton.translatesAutoresizingMaskIntoConstraints = false
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(voteLabel)
        textStackView.addArrangedSubview(occurrenceButton)
        
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(posterImageView)
        cellStackView.addArrangedSubview(textStackView)
        self.contentView.addSubview(cellStackView)
        cellStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        cellStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        let CSVbottomConstraint = cellStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        CSVbottomConstraint.priority = UILayoutPriority.defaultLow
        CSVbottomConstraint.isActive = true
        
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(seperatorView)
        seperatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    func addTargets() {
        occurrenceButton.addTarget(self,
                                   action: #selector(didPressOccuranceButton),
                                   for: .touchUpInside)
    }
    
    @objc func didPressOccuranceButton() {
        guard let title = titleLabel.text,
              let delegate = delegate
        else { return }
        
        delegate.didPressCharacterOccurence(title: title)
    }
    
    func populate(with model: MovieResultResponseModel,
                  delegate: MovieCollectionViewCellDelegate) {
        self.delegate = delegate
        titleLabel.text = model.title
        voteLabel.text = "Vote : " + String(format: "%.2f", model.voteAverage ?? 0)
        posterImageView.setImage(path: model.posterPath)
    }
    
}

//
//  HomeViewController.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 20.01.2024.
//

import UIKit
import Combine

final class HomeViewController: BaseViewController {
    private let vm: HomeViewModelLogic
    
    private lazy var searchBar: SearchBarView = {
        let view = SearchBarView(frame: .zero)
        view.setDelegate(delegate: self)
        return view
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width,
                                              height: .leastNonzeroMagnitude)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
        
    private var searchText: String? = nil
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(vm: HomeViewModelLogic) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setUI()
        setLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        hideKeyboardWhenTappedAround()
        input.send(.fetchMovies)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            guard let self = self
            else { return }
            
            switch event {
            case .displayLoading(let isOn):
                isOn ? showProgressHUD() : hideProgressHUD()
                
            case .displayData:
                self.collectionView.reloadData()
            }
            
        }.store(in: &cancellables)
                
    }
    
    private func setUI() {
        self.view.backgroundColor = .tmdbDarkBlue
        self.navigationItem.title = ""
    }
    
    private func hideNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func fetchMoreMovies() {
        if let text = searchText {
            input.send(.searchMoreMovies(searchText: text))
        } else {
            input.send(.fetchMoreMovies)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}

// MARK: - CollectionView Stuff
extension HomeViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return vm.getDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.populate(with: vm.getData(at: indexPath.row),
                      delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if vm.getDataCount() - 2 < indexPath.row {
            fetchMoreMovies()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        input.send(.didSelectData(at: indexPath.row))
    }
    
}

// MARK: - Search Delegates
extension HomeViewController: SearhBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        let spaceDeletedText = searchText.replacingOccurrences(of: " ", with: "")
        if spaceDeletedText != "" {
            self.searchText = searchText
            input.send(.searchMovies(searchText: searchText))
        } else if searchText == "" {
            self.searchText = nil
            input.send(.fetchMovies)
        }
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchText = nil
        input.send(.fetchMovies)
        return true
    }
    
}

// MARK: - Cell Delegates
extension HomeViewController: MovieCollectionViewCellDelegate {
    func didPressCharacterOccurence(title: String) {
        input.send(.didPressOccurrenceButton(title: title))
    }
    
}

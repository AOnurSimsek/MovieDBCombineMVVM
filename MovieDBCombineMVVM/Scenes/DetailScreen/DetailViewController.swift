//
//  DetailViewController.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit
import Combine

final class DetailViewController: BaseViewController {
    private let vm: DetailViewModelLogic
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.separatorInset = .init(top: 0,
                                    left: 20,
                                    bottom: 0,
                                    right: 20)
        view.separatorColor = .tmdbLightGreen
        view.estimatedRowHeight = 60
        view.register(InformationTableViewCell.self,
                      forCellReuseIdentifier: InformationTableViewCell.reuseIdentifier)
        view.register(ImageTableViewCell.self,
                      forCellReuseIdentifier: ImageTableViewCell.reuseIdentifier)
        view.register(ButtonTableViewCell.self,
                      forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        return view
    }()
    
    private let input: PassthroughSubject<DetailViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(vm: DetailViewModelLogic) {
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
        input.send(.fetchMovie)
    }
    
    private func setUI() {
        self.view.backgroundColor = .tmdbDarkBlue
        self.navigationItem.title = "Movie Detail"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
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
                self.tableView.reloadData()
            }
            
        }.store(in: &cancellables)
                
    }
    
}

// MARK: - TableView Stuff
extension DetailViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return vm.getRowCount()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = vm.getSectionType(at: indexPath.section)
        let cellData = vm.getCellData(type: currentSection)
        
        switch currentSection {
        case .imageAndTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! ImageTableViewCell
            cell.populate(with: cellData)
            return cell
            
        case .overview:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! InformationTableViewCell
            cell.populate(with: cellData)
            return cell
            
        case .genre:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! InformationTableViewCell
            cell.populate(with: cellData)
            return cell
            
        case .vote:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! InformationTableViewCell
            cell.populate(with: cellData)
            return cell
            
        case .releaseDate:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! InformationTableViewCell
            cell.populate(with: cellData)
            return cell
            
        case .imdbButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! ButtonTableViewCell
            cell.populate(with: cellData)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let currentSection = vm.getSectionType(at: indexPath.section)
        
        switch currentSection {
        case .imdbButton:
            input.send(.didPressImdbButton)
            
        default:
            return
            
        }
        
    }
    
}

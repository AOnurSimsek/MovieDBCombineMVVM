//
//  OccurenceViewController.swift
//  MovieDBMVP
//
//  Created by Abdullah Onur Şimşek on 22.01.2024.
//

import UIKit
import Combine

final class OccurenceViewController: BaseViewController {
    private let vm: OccurenceViewModelLogic

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.allowsSelection = false
        view.dataSource = self
        view.delegate = self
        view.separatorInset = .init(top: 0,
                                    left: 20,
                                    bottom: 0,
                                    right: 20)
        view.separatorColor = .tmdbLightGreen
        view.estimatedRowHeight = 60
        
        view.register(TextTableViewCell.self,
                      forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)
        return view
    }()
    
    private let input: PassthroughSubject<OccurenceViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
        
    init(vm: OccurenceViewModelLogic) {
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
        input.send(.calculateOccurence)
    }
    
    private func setUI() {
        self.view.backgroundColor = .tmdbDarkBlue
        self.navigationItem.title = "Character Occurence"
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
extension OccurenceViewController: UITableViewDelegate,
                                   UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return vm.getRowCount()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath) as! TextTableViewCell
        if indexPath.row == 0 {
            cell.populate(with: vm.getTitle())
        } else {
            cell.populate(with: vm.getData(at: indexPath.row - 1))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

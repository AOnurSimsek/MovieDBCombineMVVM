//
//  OccurenceViewModel.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 2.02.2024.
//

import Foundation
import Combine

protocol OccurenceViewModelLogic: AnyObject {
    func getRowCount() -> Int
    func getData(at index: Int) -> OccurenceModel
    func getTitle() -> String
    func getAllData() -> [OccurenceModel]
    func transform(input: AnyPublisher<OccurenceViewModel.Input, Never>) -> AnyPublisher<OccurenceViewModel.Output, Never>
}

final class OccurenceViewModel: OccurenceViewModelLogic {
    enum Input {
        case calculateOccurence
    }
    
    enum Output {
        case displayLoading(isOn: Bool)
        case displayData
    }
    
    private var data: [OccurenceModel] = []
    private var title: String
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(title: String) {
        self.title = title
    }
    
    func getRowCount() -> Int {
        return (data.count == 0) ? 0 : data.count + 1
    }
    
    func getData(at index: Int) -> OccurenceModel {
        return data[index]
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getAllData() -> [OccurenceModel] {
        return data
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.sink { [weak self] event in
            guard let self = self
            else { return }
            
            switch event {
            case .calculateOccurence:
                self.calculateOccurence()
                
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func calculateOccurence() {
        output.send(.displayLoading(isOn: true))
        let arrangedTitle = title.replacingOccurrences(of: " ", with: "").lowercased()
        let characters = Array(arrangedTitle)
        var dataDictionary: [String:Int] = [:]
        characters.forEach { character in
            let char = String(character)
            
            if let value = dataDictionary[char] {
                let newValue = value + 1
                dataDictionary[char] = newValue
            } else {
                dataDictionary[char] = 1
            }
            
        }
        
        self.data = dataDictionary.map {
            return .init(character: $0.key, value: String($0.value))
        }
        
        output.send(.displayLoading(isOn: false))
    }
    
}

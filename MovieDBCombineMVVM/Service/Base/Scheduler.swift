//
//  Scheduler.swift
//  MovieDBCombineMVVM
//
//  Created by Abdullah Onur Şimşek on 1.02.2024.
//

import Foundation
import Combine

final class Scheduler {
    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main
}

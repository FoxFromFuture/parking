//
//  MoreInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MoreInteractor {
    // MARK: - Private Properties
    private let presenter: MorePresentationLogic
    private let worker: MoreWorkerLogic
    
    // MARK: - Initializers
    init(presenter: MorePresentationLogic, worker: MoreWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension MoreInteractor: MoreBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(Model.Home.Response())
    }
}

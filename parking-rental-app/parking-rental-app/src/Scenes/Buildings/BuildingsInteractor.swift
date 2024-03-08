//
//  BuildingsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

final class BuildingsInteractor {
    // MARK: - Private Properties
    private let presenter: BuildingsPresentationLogic
    private let worker: BuildingsWorkerLogic
    
    // MARK: - Initializers
    init(presenter: BuildingsPresentationLogic, worker: BuildingsWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension BuildingsInteractor: BuildingsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}

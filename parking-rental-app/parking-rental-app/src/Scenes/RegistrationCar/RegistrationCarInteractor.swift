//
//  RegistrationCarInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCarInteractor {
    // MARK: - Private Properties
    private let presenter: RegistrationCarPresentationLogic
    private let worker: RegistrationCarWorkerLogic
    
    // MARK: - Initializers
    init(presenter: RegistrationCarPresentationLogic, worker: RegistrationCarWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension RegistrationCarInteractor: RegistrationCarBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: RegistrationCarModel.Home.Request) {
        worker.saveCarRegistryNumber(registryNumber: request.carRegistryNumber) { [weak self] carData, error in
            if let error = error {
                // TODO: - Present failure
                print(error)
            } else if let _ = carData {
                self?.presenter.presentHome(Model.Home.Response())
            }
        }
    }
}

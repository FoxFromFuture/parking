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
    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    init(presenter: RegistrationCarPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension RegistrationCarInteractor: RegistrationCarBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: RegistrationCarModel.Home.Request) {
        self.networkManager.addNewCar(model: request.carModel, registryNumber: request.carRegistryNumber) { [weak self] carData, error in
            if let error = error {
                print(error)
                self?.presenter.presentCarSetupFailure(RegistrationCarModel.CarSetupFailure.Response())
            } else if let _ = carData {
                self?.presenter.presentHome(Model.Home.Response())
            }
        }
    }
}

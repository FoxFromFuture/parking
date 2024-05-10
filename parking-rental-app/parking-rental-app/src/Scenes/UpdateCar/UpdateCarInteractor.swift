//
//  UpdateCarInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

final class UpdateCarInteractor {
    // MARK: - Private Properties
    private let presenter: UpdateCarPresentationLogic
    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    init(presenter: UpdateCarPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension UpdateCarInteractor: UpdateCarBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadProfile(_ request: Model.Profile.Request) {
        presenter.presentProfile(Model.Profile.Response())
    }
    
    func loadUpdateCarRequest(_ request: Model.UpdateCarRequest.Request) {
        self.networkManager.updateCar(id: request.carID, model: request.newModel, registryNumber: request.newRegistryNumber) { [weak self] carData, error in
            if let error = error {
                print(error)
                self?.presenter.presentUpdateCarFailure(UpdateCarModel.CarUpdateFailure.Response())
            } else if let _ = carData {
                self?.presenter.presentUpdateCarRequest(UpdateCarModel.UpdateCarRequest.Response())
            }
        }
    }
}

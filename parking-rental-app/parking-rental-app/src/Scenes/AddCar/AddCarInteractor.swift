//
//  AddCarInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit
import Logging

final class AddCarInteractor {
    // MARK: - Private Properties
    private let presenter: AddCarPresentationLogic
    private let networkManager = NetworkManager()
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.addCar")
    
    // MARK: - Initializers
    init(presenter: AddCarPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension AddCarInteractor: AddCarBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadAccountCars(_ request: Model.AccountCars.Request) {
        presenter.presentAccountCars(AddCarModel.AccountCars.Response())
    }
    
    func loadAddCarRequest(_ request: Model.AddCarRequest.Request) {
        self.networkManager.addNewCar(model: request.model, registryNumber: request.registryNumber) { [weak self] carData, error in
            if let error = error {
                self?.logger.error("Add new car error: \(error.rawValue)")
                self?.presenter.presentAddCarFailure(AddCarModel.AddCarFailure.Response())
            } else if let _ = carData {
                self?.presenter.presentAddCarRequest(AddCarModel.AddCarRequest.Response())
            }
        }
    }
}

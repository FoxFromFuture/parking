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
    private let worker: UpdateCarWorkerLogic
    
    // MARK: - Initializers
    init(presenter: UpdateCarPresentationLogic, worker: UpdateCarWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
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
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(Model.More.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(Model.Home.Response())
    }
    
    func loadUpdateCarRequest(_ request: Model.UpdateCarRequest.Request) {
        self.worker.getAllCars { carsData, error in
            if let error = error {
                // TODO: Present failure
                print(error)
            } else if let cars = carsData {
                CarsDataStore.shared.cars = cars
                if let id = CarsDataStore.shared.cars?[0].id {
                    print("ok")
                    self.worker.updateCar(id: id, newRegistryNumber: request.newRegistryNumber) { [weak self] carData, error in
                        if let error = error {
                            // TODO: Present failure
                            print(error)
                        } else if let _ = carData {
                            self?.presenter.presentUpdateCarRequest(UpdateCarModel.UpdateCarRequest.Response())
                        }
                    }
                }
            }
        }
    }
}

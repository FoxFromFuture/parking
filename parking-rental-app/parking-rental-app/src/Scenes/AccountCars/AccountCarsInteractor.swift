//
//  AccountCarsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

import UIKit

final class AccountCarsInteractor {
    // MARK: - Private Properties
    private let presenter: AccountCarsPresentationLogic
    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    init(presenter: AccountCarsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension AccountCarsInteractor: AccountCarsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadProfile(_ request: Model.Profile.Request) {
        presenter.presentProfile(Model.Profile.Response())
    }
    
    func loadAccountCarsRequest(_ request: Model.AccountCarsRequest.Request) {
        self.networkManager.getAllCars { [weak self] carsData, error in
            if let error = error {
                print(error)
                self?.presenter.presentAccountCarsFailure(AccountCarsModel.AccountCarsFailure.Response())
            } else if let cars = carsData {
                let isLimit = cars.count == 3
                self?.presenter.presentAccountCarsRequest(Model.AccountCarsRequest.Response(isLimit: isLimit, cars: cars))
            }
        }
    }
    
    func loadCarDetails(_ request: Model.CarDetails.Request) {
        presenter.presentCarDetails(Model.CarDetails.Response(carID: request.carID))
    }
    
    func loadAddCar(_ request: Model.AddCar.Request) {
        presenter.presentAddCar(Model.AddCar.Response())
    }
}

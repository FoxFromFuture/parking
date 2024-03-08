//
//  RegistrationCityInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCityInteractor {
    // MARK: - Private Properties
    private let presenter: RegistrationCityPresentationLogic
    private let worker: RegistrationCityWorkerLogic
    
    // MARK: - Initializers
    init(presenter: RegistrationCityPresentationLogic, worker: RegistrationCityWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension RegistrationCityInteractor: RegistrationCityBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadRegistrationCar(_ request: RegistrationCityModel.RegistrationCar.Request) {
        worker.saveCity(city: request.city)
        presenter.presentRegistrationCar(Model.RegistrationCar.Response())
    }
}

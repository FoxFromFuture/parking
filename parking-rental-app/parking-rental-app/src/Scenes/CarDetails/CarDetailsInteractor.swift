//
//  CarDetailsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit
import Logging

final class CarDetailsInteractor {
    // MARK: - Private Properties
    private let presenter: CarDetailsPresentationLogic
    private let networkManager = NetworkManager()
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.carDetails")
    private var carID: String?
    
    // MARK: - Initializers
    init(presenter: CarDetailsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension CarDetailsInteractor: CarDetailsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadCarDetails(_ request: Model.CarDetails.Request) {
        self.carID = request.carID
        self.networkManager.getAllCars(completion: { [weak self] carsData, error in
            if let error = error {
                self?.logger.error("Get all cars error: \(error.rawValue)")
            } else if let cars = carsData {
                var curCar: Car?
                if let carID = self?.carID {
                    for car in cars {
                        if car.id == carID {
                            curCar = car
                            break
                        }
                    }
                }
                let isOnlyOneCarLasts = cars.count == 1
                if let car = curCar {
                    self?.presenter.presentCarDetails(CarDetailsModel.CarDetails.Response(car: car, isOnlyOneCarLasts: isOnlyOneCarLasts))
                }
            }
        })
    }
    
    func loadAccountCars(_ request: Model.AccountCars.Request) {
        presenter.presentAccountCars(CarDetailsModel.AccountCars.Response())
    }
    
    func loadUpdateCar(_ request: Model.UpdateCar.Request) {
        presenter.presentUpdateCar(CarDetailsModel.UpdateCar.Response(carID: request.carID))
    }
    
    func loadDeleteCar(_ request: Model.DeleteCar.Request) {
        self.networkManager.deleteCar(carID: request.carID) { [weak self] error in
            if let error = error {
                self?.logger.error("Delete car error: \(error.rawValue)")
                self?.presenter.presentCarDetailsFailure(CarDetailsModel.CarDetailsFailure.Response())
            } else {
                self?.presenter.presentDeleteCar(CarDetailsModel.DeleteCar.Response())
            }
        }
    }
}

//
//  UpdateCarWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

final class UpdateCarWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
}

// MARK: - WorkerLogic
extension UpdateCarWorker: UpdateCarWorkerLogic {
    func updateCar(id: String, newRegistryNumber: String, completion: @escaping (_ carData: Car?, _ error: String?) -> ()) {
        self.networkManager.updateCar(id: id, registryNumber: newRegistryNumber) { carData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = carData {
                completion(data, nil)
            }
        }
    }
    
    func getAllCars(completion: @escaping ([Car]?, String?) -> ()) {
        self.networkManager.getAllCars { carsData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = carsData {
                completion(data, nil)
            }
        }
    }
}

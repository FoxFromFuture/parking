//
//  RegistrationCarWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCarWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager()
}

// MARK: - WorkerLogic
extension RegistrationCarWorker: RegistrationCarWorkerLogic {
    func saveCarRegistryNumber(model: String, registryNumber: String, completion: @escaping (Car?, String?) -> ()) {
        self.networkManager.addNewCar(model: model, registryNumber: registryNumber) { carData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = carData {
                completion(data, nil)
            }
        }
    }
}

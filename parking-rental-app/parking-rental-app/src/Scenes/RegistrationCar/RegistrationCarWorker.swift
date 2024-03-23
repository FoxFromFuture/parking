//
//  RegistrationCarWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCarWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private let defaults = UserDefaults.standard
}

// MARK: - WorkerLogic
extension RegistrationCarWorker: RegistrationCarWorkerLogic {
    func saveCarRegistryNumber(registryNumber: String, completion: @escaping (Car?, String?) -> ()) {
        self.networkManager.addNewCar(registryNumber: registryNumber) { [weak self] carData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = carData {
                completion(data, nil)
//                self?.defaults.set(registryNumber, forKey: "carRegistryNumber")
            }
        }
    }
}

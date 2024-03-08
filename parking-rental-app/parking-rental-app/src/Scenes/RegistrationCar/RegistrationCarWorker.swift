//
//  RegistrationCarWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCarWorker {
    // MARK: - Private Properties
    let defaults = UserDefaults.standard
}

// MARK: - WorkerLogic
extension RegistrationCarWorker: RegistrationCarWorkerLogic {
    func saveCarRegistryNumber(registryNumber: String) {
        defaults.set(registryNumber, forKey: "carRegistryNumber")
    }
}

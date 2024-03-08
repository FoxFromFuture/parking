//
//  RegistrationCityWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCityWorker {
    // MARK: - Private Properties
    let defaults = UserDefaults.standard
}

// MARK: - WorkerLogic
extension RegistrationCityWorker: RegistrationCityWorkerLogic {
    func saveCity(city: String) {
        defaults.set(city, forKey: "city")
    }
}

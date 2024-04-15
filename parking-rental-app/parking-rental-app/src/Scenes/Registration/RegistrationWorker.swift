//
//  RegistrationWorker.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

final class RegistrationWorker {
    // MARK: - Private Properties
    private let networkManager = NetworkManager()
    private let authManager = AuthManager()
}

// MARK: - WorkerLogic
extension RegistrationWorker: RegistrationWorkerLogic {
    func signUp(_ request: RegistrationModel.RegistrationCar.Request, completion: @escaping (AuthApiResponse?, String?) -> ()) {
        networkManager.signup(name: request.name, email: request.email, password: request.password) { authData, error in
            if let error = error {
                completion(nil, error)
            } else if let data = authData {
                completion(data, nil)
            }
        }
    }
    
    func saveAuthTokens(refreshToken: String, accessToken: String) {
        self.authManager.saveTokens(refreshToken: refreshToken, accessToken: accessToken)
        self.authManager.setRefreshTokenLastUpdateDate(date: Date.now)
    }
}

//
//  RegistrationInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

final class RegistrationInteractor {
    // MARK: - Private Properties
    private let presenter: RegistrationPresentationLogic
    private let networkManager = NetworkManager()
    private let authManager = AuthManager()
    
    // MARK: - Initializers
    init(presenter: RegistrationPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    func saveAuthTokens(refreshToken: String, accessToken: String) {
        self.authManager.saveTokens(refreshToken: refreshToken, accessToken: accessToken)
        self.authManager.setRefreshTokenLastUpdateDate(date: Date.now)
    }
}

// MARK: - BusinessLogic
extension RegistrationInteractor: RegistrationBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadRegistrationCar(_ request: RegistrationModel.RegistrationCar.Request) {
        networkManager.signup(name: request.name, email: request.email, password: request.password) { [weak self] authData, error in
            if let error = error {
                print(error)
                self?.presenter.presentRegistrationFailure(RegistrationModel.RegistrationFailure.Response())
            } else if let authData = authData {
                self?.saveAuthTokens(refreshToken: authData.refreshToken, accessToken: authData.accessToken)
                self?.presenter.presentRegistrationCar(Model.RegistrationCar.Response())
            }
        }
    }
    
    func loadLogin(_ request: RegistrationModel.Login.Request) {
        presenter.presentLogin(Model.Login.Response())
    }
}

//
//  LoginInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

final class LoginInteractor {
    // MARK: - Private Properties
    private let presenter: LoginPresentationLogic
    private let networkManager = NetworkManager()
    private let authManager = AuthManager()
    
    // MARK: - Initializers
    init(presenter: LoginPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func saveAuthTokens(refreshToken: String, accessToken: String) {
        self.authManager.saveTokens(refreshToken: refreshToken, accessToken: accessToken)
        self.authManager.setRefreshTokenLastUpdateDate(date: Date.now)
    }
}

// MARK: - BusinessLogic
extension LoginInteractor: LoginBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        networkManager.login(email: request.email, password: request.password) { [weak self] authData, error in
            if let error = error {
                print(error)
                self?.presenter.presentLoginFailure(LoginModel.LoginFailure.Response())
            } else if let authData = authData {
                self?.saveAuthTokens(refreshToken: authData.refreshToken, accessToken: authData.accessToken)
                self?.presenter.presentHome(Model.Home.Response())
            }
        }
    }
    
    func loadRegistration(_ request: Model.Registration.Request) {
        presenter.presentRegistration(Model.Registration.Response())
    }
}

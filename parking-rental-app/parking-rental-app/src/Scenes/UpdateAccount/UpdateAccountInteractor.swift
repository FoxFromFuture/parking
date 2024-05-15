//
//  UpdateAccountInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit
import Logging

final class UpdateAccountInteractor {
    // MARK: - Private Properties
    private let presenter: UpdateAccountPresentationLogic
    private let networkManager = NetworkManager()
    private let authManager = AuthManager()
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.updateAccount")
    
    // MARK: - Initializers
    init(presenter: UpdateAccountPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func updateAuthTokens(refreshToken: String, accessToken: String) {
        self.authManager.updateToken(token: refreshToken, tokenType: .refresh)
        self.authManager.updateToken(token: accessToken, tokenType: .access)
        self.authManager.setRefreshTokenLastUpdateDate(date: Date.now)
    }
}

// MARK: - BusinessLogic
extension UpdateAccountInteractor: UpdateAccountBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadAccountDetails(_ request: Model.AccountDetails.Request) {
        presenter.presentAccountDetails(UpdateAccountModel.AccountDetails.Response())
    }
    
    func loadUpdateAccountRequest(_ request: Model.UpdateAccountRequest.Request) {
        self.networkManager.updateEmployee(name: request.name, email: request.email, password: request.password) { [weak self] authData, error in
            if let error = error {
                self?.logger.error("Update user error: \(error.rawValue)")
                self?.presenter.presentUpdateAccountFailure(Model.UpdateAccountFailure.Response())
            } else if let authData = authData {
                self?.updateAuthTokens(refreshToken: authData.refreshToken, accessToken: authData.accessToken)
                self?.presenter.presentUpdateAccountRequest(UpdateAccountModel.UpdateAccountRequest.Response())
            }
        }
    }
}

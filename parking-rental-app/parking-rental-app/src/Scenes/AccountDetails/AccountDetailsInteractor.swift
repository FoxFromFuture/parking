//
//  AccountDetailsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit
import Logging

final class AccountDetailsInteractor {
    // MARK: - Private Properties
    private let presenter: AccountDetailsPresentationLogic
    private let networkManager = NetworkManager()
    private let authManager = AuthManager()
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.accountDetails")
    
    // MARK: - Initializers
    init(presenter: AccountDetailsPresentationLogic) {
        self.presenter = presenter
    }
    
    private func clearUserData() {
        self.authManager.deleteRefreshTokenLastUpdateDate()
        self.authManager.deleteToken(tokenType: .access)
        self.authManager.deleteToken(tokenType: .refresh)
    }
}

// MARK: - BusinessLogic
extension AccountDetailsInteractor: AccountDetailsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadProfile(_ request: Model.Profile.Request) {
        presenter.presentProfile(AccountDetailsModel.Profile.Response())
    }
    
    func loadUserDetails(_ request: Model.UserDetails.Request) {
        self.networkManager.whoami { [weak self] authData, error in
            if let error = error {
                self?.logger.error("Load user details error: \(error.rawValue)")
            } else if let user = authData {
                self?.presenter.presentUserDetails(AccountDetailsModel.UserDetails.Response(user: user))
            }
        }
    }
    
    func loadLogin(_ request: Model.Login.Request) {
        self.networkManager.deleteEmployee { [weak self] error in
            if let error = error {
                self?.logger.error("Delete user error: \(error.rawValue)")
                self?.presenter.presentUpdateAccountFailure(AccountDetailsModel.UpdateAccountFailure.Response())
            } else {
                self?.clearUserData()
                self?.presenter.presentLogin(AccountDetailsModel.Login.Response())
            }
        }
    }
    
    func loadUpdateAccount(_ request: Model.UpdateAccount.Request) {
        presenter.presentUpdateAccount(AccountDetailsModel.UpdateAccount.Response())
    }
}

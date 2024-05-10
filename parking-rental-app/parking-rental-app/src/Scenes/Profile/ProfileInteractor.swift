//
//  ProfileInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class ProfileInteractor {
    // MARK: - Private Properties
    private let presenter: ProfilePresentationLogic
    private let authManager = AuthManager()
    
    // MARK: - Initializers
    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func clearUserData() {
        self.authManager.deleteRefreshTokenLastUpdateDate()
        self.authManager.deleteToken(tokenType: .access)
        self.authManager.deleteToken(tokenType: .refresh)
    }
}

// MARK: - BusinessLogic
extension ProfileInteractor: ProfileBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(Model.Home.Response())
    }
    
    func loadAccountCars(_ request: Model.AccountCars.Request) {
        presenter.presentAccountCars(Model.AccountCars.Response())
    }
    
    func loadLogin(_ request: Model.Login.Request) {
        self.clearUserData()
        presenter.presentLogin(Model.Login.Response())
    }
    
    func loadAccountDetails(_ request: Model.AccountDetails.Request) {
        presenter.presentAccountDetails(ProfileModel.AccountDetails.Response())
    }
}

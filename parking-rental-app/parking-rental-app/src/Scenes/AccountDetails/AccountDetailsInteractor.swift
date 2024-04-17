//
//  AccountDetailsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

final class AccountDetailsInteractor {
    // MARK: - Private Properties
    private let presenter: AccountDetailsPresentationLogic
    private let networkManager = NetworkManager()
    private let authManager = AuthManager()
    
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
                print(error)
            } else if let user = authData {
                self?.presenter.presentUserDetails(AccountDetailsModel.UserDetails.Response(user: user))
            }
        }
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(AccountDetailsModel.More.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(AccountDetailsModel.Home.Response())
    }
    
    func loadLogin(_ request: Model.Login.Request) {
        self.networkManager.deleteEmployee { [weak self] error in
            if let error = error {
                print(error)
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

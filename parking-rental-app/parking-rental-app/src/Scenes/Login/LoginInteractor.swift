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
    private let worker: LoginWorkerLogic
    
    // MARK: - Initializers
    init(presenter: LoginPresentationLogic, worker: LoginWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension LoginInteractor: LoginBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        worker.login(request) { [weak self] authData, error in
            if let error = error {
                print(error)
                /// TODO: Present failure
            } else if let authData = authData {
                self?.worker.saveAuthTokens(refreshToken: authData.refreshToken, accessToken: authData.accessToken)
                self?.presenter.presentHome(Model.Home.Response())
            }
        }
    }
    
    func loadRegistration(_ request: Model.Registration.Request) {
        presenter.presentRegistration(Model.Registration.Response())
    }
}

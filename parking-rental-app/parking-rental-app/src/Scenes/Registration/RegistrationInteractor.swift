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
    private let worker: RegistrationWorkerLogic
    
    // MARK: - Initializers
    init(presenter: RegistrationPresentationLogic, worker: RegistrationWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension RegistrationInteractor: RegistrationBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadRegistrationCar(_ request: RegistrationModel.RegistrationCar.Request) {
        worker.signUp(request) { [weak self] authData, error in
            if let error = error {
                print(error)
                self?.presenter.presentRegistrationFailure(RegistrationModel.RegistrationFailure.Response())
            } else if let authData = authData {
                self?.worker.saveAuthTokens(refreshToken: authData.refreshToken, accessToken: authData.accessToken)
                self?.presenter.presentRegistrationCar(Model.RegistrationCar.Response())
            }
        }
    }
    
    func loadLogin(_ request: RegistrationModel.Login.Request) {
        presenter.presentLogin(Model.Login.Response())
    }
}

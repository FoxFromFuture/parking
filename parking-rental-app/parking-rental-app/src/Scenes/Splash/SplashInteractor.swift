//
//  SplashInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit

final class SplashInteractor {
    // MARK: - Private Properties
    private let presenter: SplashPresentationLogic
    private let worker: SplashWorkerLogic
    private let twoWeeksInSec: Double = 1209600.0
    private let authManager = AuthManager()
    
    // MARK: - Initializers
    init(presenter: SplashPresentationLogic, worker: SplashWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: - BusinessLogic
extension SplashInteractor: SplashBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadLogin(_ request: Model.Login.Request) {
        if self.worker.wasUserLogined() {
            if let date = authManager.getRefreshTokenLastUpdateDate(), date.timeIntervalSinceNow >= twoWeeksInSec {
                self.worker.tryUpdateRefreshToken { [weak self] authData, error in
                    if authData != nil {
                        self?.presenter.presentHome(Model.Home.Response())
                    } else {
                        if let error = error {
                            print(error)
                        }
                        self?.presenter.presentLogin(Model.Login.Response())
                    }
                }
                self.authManager.setRefreshTokenLastUpdateDate(date: Date.now)
            } else {
                self.presenter.presentHome(Model.Home.Response())
            }
        } else {
            presenter.presentLogin(Model.Login.Response())
        }
    }
}

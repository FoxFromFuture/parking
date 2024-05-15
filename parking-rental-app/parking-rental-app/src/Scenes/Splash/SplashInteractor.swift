//
//  SplashInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit
import Logging

final class SplashInteractor {
    // MARK: - Private Properties
    private let presenter: SplashPresentationLogic
    private let twoWeeksInSec: Double = 1209600.0
    private let authManager = AuthManager()
    private let networkManager = NetworkManager()
    private let logger = Logger(label: "com.foxfromfuture.parking-rental-app.splash")
    
    // MARK: - Initializers
    init(presenter: SplashPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func wasUserLogined() -> Bool {
        guard let _ = authManager.getRefreshToken() else { return false }
        return true
    }
}

// MARK: - BusinessLogic
extension SplashInteractor: SplashBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadLogin(_ request: Model.Login.Request) {
        if self.wasUserLogined() {
            if let date = authManager.getRefreshTokenLastUpdateDate(), date.timeIntervalSinceNow >= twoWeeksInSec {
                self.networkManager.updateRefreshToken { [weak self] authData, error in
                    if let data = authData {
                        if !(self?.authManager.updateToken(token: data.refreshToken, tokenType: .refresh) ?? false) {
                            self?.presenter.presentLogin(Model.Login.Response())
                        } else {
                            self?.presenter.presentHome(Model.Home.Response())
                        }
                    } else {
                        if let error = error {
                            self?.logger.error("Update refresh token error: \(error.rawValue)")
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

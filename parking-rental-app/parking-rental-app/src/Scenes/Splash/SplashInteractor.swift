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
        if worker.wasUserLogined() {
            presenter.presentHome(Model.Home.Response())
        } else {
            presenter.presentLogin(Model.Login.Response())
        }
    }
}

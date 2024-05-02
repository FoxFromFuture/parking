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
    private let worker: ProfileWorkerLogic
    
    // MARK: - Initializers
    init(presenter: ProfilePresentationLogic, worker: ProfileWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
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
        self.worker.clearUserData()
        presenter.presentLogin(Model.Login.Response())
    }
    
    func loadAccountDetails(_ request: Model.AccountDetails.Request) {
        presenter.presentAccountDetails(ProfileModel.AccountDetails.Response())
    }
}

//
//  NotAuthMoreInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/29/24.
//

import UIKit

final class NotAuthMoreInteractor {
    // MARK: - Private Properties
    private let presenter: NotAuthMorePresentationLogic
    
    // MARK: - Initializers
    init(presenter: NotAuthMorePresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension NotAuthMoreInteractor: NotAuthMoreBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadNotAuthSettings(_ request: Model.NotAuthSettings.Request) {
        presenter.presentNotAuthSettings(NotAuthMoreModel.NotAuthSettings.Response())
    }
    
    func loadNotAuthContactDevs(_ request: Model.NotAuthContactDevs.Request) {
        presenter.presentNotAuthContactDevs(NotAuthMoreModel.NotAuthContactDevs.Response())
    }
}

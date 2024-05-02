//
//  NotAuthContactDevsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

final class NotAuthContactDevsInteractor {
    // MARK: - Private Properties
    private let presenter: NotAuthContactDevsPresentationLogic
    
    // MARK: - Initializers
    init(presenter: NotAuthContactDevsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension NotAuthContactDevsInteractor: NotAuthContactDevsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadNotAuthMore(_ request: Model.NotAuthMore.Request) {
        presenter.presentNotAuthMore(NotAuthContactDevsModel.NotAuthMore.Response())
    }
    
    func loadGitHubLink(_ request: Model.GitHubLink.Request) {
        presenter.presentGitHubLink(NotAuthContactDevsModel.GitHubLink.Response())
    }
}

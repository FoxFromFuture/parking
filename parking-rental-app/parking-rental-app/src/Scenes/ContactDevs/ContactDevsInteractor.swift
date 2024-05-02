//
//  ContactDevsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/27/24.
//

import UIKit

final class ContactDevsInteractor {
    // MARK: - Private Properties
    private let presenter: ContactDevsPresentationLogic
    
    // MARK: - Initializers
    init(presenter: ContactDevsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension ContactDevsInteractor: ContactDevsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(ContactDevsModel.More.Response())
    }
    
    func loadGitHubLink(_ request: Model.GitHubLink.Request) {
        presenter.presentGitHubLink(ContactDevsModel.GitHubLink.Response())
    }
}

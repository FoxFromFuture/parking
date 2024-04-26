//
//  FAQInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

final class FAQInteractor {
    // MARK: - Private Properties
    private let presenter: FAQPresentationLogic
    
    // MARK: - Initializers
    init(presenter: FAQPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension FAQInteractor: FAQBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(FAQModel.Home.Response())
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(FAQModel.More.Response())
    }
}

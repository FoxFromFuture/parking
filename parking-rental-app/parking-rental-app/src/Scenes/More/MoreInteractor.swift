//
//  MoreInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MoreInteractor {
    // MARK: - Private Properties
    private let presenter: MorePresentationLogic
    
    // MARK: - Initializers
    init(presenter: MorePresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension MoreInteractor: MoreBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadSettings(_ request: Model.Settings.Request) {
        presenter.presentSettings(MoreModel.Settings.Response())
    }
    
    func loadFAQ(_ request: Model.FAQ.Request) {
        presenter.presentFAQ(MoreModel.FAQ.Response())
    }
    
    func loadContactDevs(_ request: Model.ContactDevs.Request) {
        presenter.presentContactDevs(MoreModel.ContactDevs.Response())
    }
}

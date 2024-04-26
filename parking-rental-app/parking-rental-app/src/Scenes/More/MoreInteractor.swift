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
    private let themeManager = ThemeManager()
    
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
    
    func loadHome(_ request: Model.Home.Request) {
        presenter.presentHome(Model.Home.Response())
    }
    
    func loadSettings(_ request: Model.Settings.Request) {
        presenter.presentSettings(MoreModel.Settings.Response())
    }
    
    func loadFAQ(_ request: Model.FAQ.Request) {
        presenter.presentFAQ(MoreModel.FAQ.Response())
    }
}

//
//  NotAuthSettingsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

final class NotAuthSettingsInteractor {
    // MARK: - Private Properties
    private let presenter: NotAuthSettingsPresentationLogic
    private let themeManager = ThemeManager()
    
    // MARK: - Initializers
    init(presenter: NotAuthSettingsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension NotAuthSettingsInteractor: NotAuthSettingsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curTheme = themeManager.theme
        presenter.presentStart(Model.Start.Response(curTheme: curTheme))
    }
    
    func loadNewTheme(_ request: Model.NewTheme.Request) {
        self.themeManager.theme = request.theme
        presenter.presentNewTheme(Model.NewTheme.Response(theme: request.theme))
    }
    
    func loadNotAuthMore(_ request: Model.NotAuthMore.Request) {
        presenter.presentNotAuthMore(NotAuthSettingsModel.NotAuthMore.Response())
    }
}

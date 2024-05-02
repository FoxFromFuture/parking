//
//  SettingsInteractor.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

final class SettingsInteractor {
    // MARK: - Private Properties
    private let presenter: SettingsPresentationLogic
    private let themeManager = ThemeManager()
    
    // MARK: - Initializers
    init(presenter: SettingsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension SettingsInteractor: SettingsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curTheme = themeManager.theme
        presenter.presentStart(Model.Start.Response(curTheme: curTheme))
    }
    
    func loadMore(_ request: Model.More.Request) {
        presenter.presentMore(SettingsModel.More.Response())
    }
    
    func loadNewTheme(_ request: Model.NewTheme.Request) {
        self.themeManager.theme = request.theme
        presenter.presentNewTheme(Model.NewTheme.Response(theme: request.theme))
    }
}

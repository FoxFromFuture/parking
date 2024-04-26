//
//  SettingsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

enum SettingsAssembly {
    static func build() -> UIViewController {
        let router: SettingsRouter = SettingsRouter()
        let presenter: SettingsPresenter = SettingsPresenter()
        let interactor: SettingsInteractor = SettingsInteractor(presenter: presenter)
        let viewController: SettingsViewController = SettingsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

//
//  NotAuthSettingsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

enum NotAuthSettingsAssembly {
    static func build() -> UIViewController {
        let router: NotAuthSettingsRouter = NotAuthSettingsRouter()
        let presenter: NotAuthSettingsPresenter = NotAuthSettingsPresenter()
        let interactor: NotAuthSettingsInteractor = NotAuthSettingsInteractor(presenter: presenter)
        let viewController: NotAuthSettingsViewController = NotAuthSettingsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

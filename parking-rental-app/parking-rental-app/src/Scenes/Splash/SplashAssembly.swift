//
//  SplashAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/23/24.
//

import UIKit

enum SplashAssembly {
    static func build() -> UIViewController {
        let router: SplashRouter = SplashRouter()
        let presenter: SplashPresenter = SplashPresenter()
        let interactor: SplashInteractor = SplashInteractor(presenter: presenter)
        let viewController: SplashViewController = SplashViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

//
//  HomeAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum HomeAssembly {
    static func build() -> UIViewController {
        let router: HomeRouter = HomeRouter()
        let presenter: HomePresenter = HomePresenter()
        let interactor: HomeInteractor = HomeInteractor(presenter: presenter)
        let viewController: HomeViewController = HomeViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

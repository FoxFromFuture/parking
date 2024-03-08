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
        let worker: HomeWorker = HomeWorker()
        let interactor: HomeInteractor = HomeInteractor(presenter: presenter, worker: worker)
        let viewController: HomeViewController = HomeViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

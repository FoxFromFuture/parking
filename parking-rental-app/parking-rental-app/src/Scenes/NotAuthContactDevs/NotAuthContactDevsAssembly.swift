//
//  NotAuthContactDevsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

enum NotAuthContactDevsAssembly {
    static func build() -> UIViewController {
        let router: NotAuthContactDevsRouter = NotAuthContactDevsRouter()
        let presenter: NotAuthContactDevsPresenter = NotAuthContactDevsPresenter()
        let interactor: NotAuthContactDevsInteractor = NotAuthContactDevsInteractor(presenter: presenter)
        let viewController: NotAuthContactDevsViewController = NotAuthContactDevsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

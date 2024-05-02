//
//  NotAuthMoreAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/29/24.
//

import UIKit

enum NotAuthMoreAssembly {
    static func build() -> UIViewController {
        let router: NotAuthMoreRouter = NotAuthMoreRouter()
        let presenter: NotAuthMorePresenter = NotAuthMorePresenter()
        let interactor: NotAuthMoreInteractor = NotAuthMoreInteractor(presenter: presenter)
        let viewController: NotAuthMoreViewController = NotAuthMoreViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

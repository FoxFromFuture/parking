//
//  MoreAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

enum MoreAssembly {
    static func build() -> UIViewController {
        let router: MoreRouter = MoreRouter()
        let presenter: MorePresenter = MorePresenter()
        let worker: MoreWorker = MoreWorker()
        let interactor: MoreInteractor = MoreInteractor(presenter: presenter, worker: worker)
        let viewController: MoreViewController = MoreViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

//
//  BuildingsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

enum BuildingsAssembly {
    static func build() -> UIViewController {
        let router: BuildingsRouter = BuildingsRouter()
        let presenter: BuildingsPresenter = BuildingsPresenter()
        let worker: BuildingsWorker = BuildingsWorker()
        let interactor: BuildingsInteractor = BuildingsInteractor(presenter: presenter, worker: worker)
        let viewController: BuildingsViewController = BuildingsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

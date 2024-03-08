//
//  RegistrationCarAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum RegistrationCarAssembly {
    static func build() -> UIViewController {
        let router: RegistrationCarRouter = RegistrationCarRouter()
        let presenter: RegistrationCarPresenter = RegistrationCarPresenter()
        let worker: RegistrationCarWorker = RegistrationCarWorker()
        let interactor: RegistrationCarInteractor = RegistrationCarInteractor(presenter: presenter, worker: worker)
        let viewController: RegistrationCarViewController = RegistrationCarViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

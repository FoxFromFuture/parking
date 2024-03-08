//
//  RegistrationCityAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

enum RegistrationCityAssembly {
    static func build() -> UIViewController {
        let router: RegistrationCityRouter = RegistrationCityRouter()
        let presenter: RegistrationCityPresenter = RegistrationCityPresenter()
        let worker: RegistrationCityWorker = RegistrationCityWorker()
        let interactor: RegistrationCityInteractor = RegistrationCityInteractor(presenter: presenter, worker: worker)
        let viewController: RegistrationCityViewController = RegistrationCityViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

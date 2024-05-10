//
//  RegistrationAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

enum RegistrationAssembly {
    static func build() -> UIViewController {
        let router: RegistrationRouter = RegistrationRouter()
        let presenter: RegistrationPresenter = RegistrationPresenter()
        let interactor: RegistrationInteractor = RegistrationInteractor(presenter: presenter)
        let viewController: RegistrationViewController = RegistrationViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

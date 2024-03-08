//
//  LoginAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/14/24.
//

import UIKit

enum LoginAssembly {
    static func build() -> UIViewController {
        let router: LoginRouter = LoginRouter()
        let presenter: LoginPresenter = LoginPresenter()
        let worker: LoginWorker = LoginWorker()
        let interactor: LoginInteractor = LoginInteractor(presenter: presenter, worker: worker)
        let viewController: LoginViewController = LoginViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

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
        let interactor: LoginInteractor = LoginInteractor(presenter: presenter)
        let viewController: LoginViewController = LoginViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

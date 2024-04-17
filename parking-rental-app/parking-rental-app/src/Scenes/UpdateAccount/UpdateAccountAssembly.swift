//
//  UpdateAccountAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

enum UpdateAccountAssembly {
    static func build() -> UIViewController {
        let router: UpdateAccountRouter = UpdateAccountRouter()
        let presenter: UpdateAccountPresenter = UpdateAccountPresenter()
        let interactor: UpdateAccountInteractor = UpdateAccountInteractor(presenter: presenter)
        let viewController: UpdateAccountViewController = UpdateAccountViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

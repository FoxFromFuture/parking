//
//  AccountCarsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/18/24.
//

import UIKit

enum AccountCarsAssembly {
    static func build() -> UIViewController {
        let router: AccountCarsRouter = AccountCarsRouter()
        let presenter: AccountCarsPresenter = AccountCarsPresenter()
        let interactor: AccountCarsInteractor = AccountCarsInteractor(presenter: presenter)
        let viewController: AccountCarsViewController = AccountCarsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

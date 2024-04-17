//
//  AccountDetailsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/17/24.
//

import UIKit

enum AccountDetailsAssembly {
    static func build() -> UIViewController {
        let router: AccountDetailsRouter = AccountDetailsRouter()
        let presenter: AccountDetailsPresenter = AccountDetailsPresenter()
        let interactor: AccountDetailsInteractor = AccountDetailsInteractor(presenter: presenter)
        let viewController: AccountDetailsViewController = AccountDetailsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

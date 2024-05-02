//
//  ContactDevsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/27/24.
//

import UIKit

enum ContactDevsAssembly {
    static func build() -> UIViewController {
        let router: ContactDevsRouter = ContactDevsRouter()
        let presenter: ContactDevsPresenter = ContactDevsPresenter()
        let interactor: ContactDevsInteractor = ContactDevsInteractor(presenter: presenter)
        let viewController: ContactDevsViewController = ContactDevsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

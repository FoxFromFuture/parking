//
//  AddCarAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

enum AddCarAssembly {
    static func build() -> UIViewController {
        let router: AddCarRouter = AddCarRouter()
        let presenter: AddCarPresenter = AddCarPresenter()
        let interactor: AddCarInteractor = AddCarInteractor(presenter: presenter)
        let viewController: AddCarViewController = AddCarViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

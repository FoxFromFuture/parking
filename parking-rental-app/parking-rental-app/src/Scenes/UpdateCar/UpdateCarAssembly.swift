//
//  UpdateCarAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

enum UpdateCarAssembly {
    static func build(carID: String) -> UIViewController {
        let router: UpdateCarRouter = UpdateCarRouter()
        let presenter: UpdateCarPresenter = UpdateCarPresenter()
        let interactor: UpdateCarInteractor = UpdateCarInteractor(presenter: presenter)
        let viewController: UpdateCarViewController = UpdateCarViewController(
            router: router,
            interactor: interactor,
            carID: carID
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

//
//  CarDetailsAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/19/24.
//

import UIKit

enum CarDetailsAssembly {
    static func build(carID: String) -> UIViewController {
        let router: CarDetailsRouter = CarDetailsRouter()
        let presenter: CarDetailsPresenter = CarDetailsPresenter()
        let interactor: CarDetailsInteractor = CarDetailsInteractor(presenter: presenter)
        let viewController: CarDetailsViewController = CarDetailsViewController(
            router: router,
            interactor: interactor,
            carID: carID
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

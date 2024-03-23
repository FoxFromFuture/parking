//
//  MapAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

enum MapAssembly {
    static func build() -> UIViewController {
        let router: MapRouter = MapRouter()
        let presenter: MapPresenter = MapPresenter()
        let worker: MapWorker = MapWorker()
        let interactor: MapInteractor = MapInteractor(presenter: presenter, worker: worker)
        let viewController: MapViewController = MapViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

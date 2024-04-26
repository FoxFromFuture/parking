//
//  FAQAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

enum FAQAssembly {
    static func build() -> UIViewController {
        let router: FAQRouter = FAQRouter()
        let presenter: FAQPresenter = FAQPresenter()
        let interactor: FAQInteractor = FAQInteractor(presenter: presenter)
        let viewController: FAQViewController = FAQViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

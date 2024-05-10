//
//  ProfileAssembly.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

enum ProfileAssembly {
    static func build() -> UIViewController {
        let router: ProfileRouter = ProfileRouter()
        let presenter: ProfilePresenter = ProfilePresenter()
        let interactor: ProfileInteractor = ProfileInteractor(presenter: presenter)
        let viewController: ProfileViewController = ProfileViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

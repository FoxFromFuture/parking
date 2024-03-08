//
//  RegistrationCarRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCarRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension RegistrationCarRouter: RegistrationCarRoutingLogic {
    func routeToHome() {
        view?.navigationController?.pushViewController(HomeAssembly.build(), animated: true)
    }
}

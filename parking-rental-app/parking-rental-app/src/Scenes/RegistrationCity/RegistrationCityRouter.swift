//
//  RegistrationCityRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 2/17/24.
//

import UIKit

final class RegistrationCityRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension RegistrationCityRouter: RegistrationCityRoutingLogic {
    func routeToRegistrationCar() {
        view?.navigationController?.pushViewController(RegistrationCarAssembly.build(), animated: true)
    }
}

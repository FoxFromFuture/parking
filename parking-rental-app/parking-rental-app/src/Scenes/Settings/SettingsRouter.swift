//
//  SettingsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

final class SettingsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension SettingsRouter: SettingsRoutingLogic {
    func routeToHome() {
        self.view?.navigationController?.pushViewController(HomeAssembly.build(), animated: false)
    }
    
    func routeToMore() {
        self.view?.navigationController?.popViewController(animated: true)
    }
}

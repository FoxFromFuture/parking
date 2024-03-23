//
//  BuildingsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/7/24.
//

import UIKit

final class BuildingsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension BuildingsRouter: BuildingsRoutingLogic {
    func routeToMore() {
        view?.navigationController?.pushViewController(MoreAssembly.build(), animated: false)
    }
    
    func routeToHome() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func routeToMap() {
        view?.navigationController?.pushViewController(MapAssembly.build(), animated: true)
    }
}

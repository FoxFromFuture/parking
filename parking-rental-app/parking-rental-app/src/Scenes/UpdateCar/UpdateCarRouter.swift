//
//  UpdateCarRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/15/24.
//

import UIKit

final class UpdateCarRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension UpdateCarRouter: UpdateCarRoutingLogic {
    func routeToProfile() {
        view?.navigationController?.popViewController(animated: true)
    }
}

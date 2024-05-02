//
//  NotAuthSettingsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

final class NotAuthSettingsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension NotAuthSettingsRouter: NotAuthSettingsRoutingLogic {
    func routeToNotAuthMore() {
        view?.navigationController?.popViewController(animated: true)
    }
}

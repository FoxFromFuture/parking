//
//  FAQRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/25/24.
//

import UIKit

final class FAQRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension FAQRouter: FAQRoutingLogic {
    func routeToMore() {
        self.view?.navigationController?.popViewController(animated: true)
    }
}

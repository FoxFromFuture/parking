//
//  NotAuthContactDevsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

final class NotAuthContactDevsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension NotAuthContactDevsRouter: NotAuthContactDevsRoutingLogic {
    func routeToNotAuthMore() {
        self.view?.dismiss(animated: true)
    }
    
    func routeToGitHubLink() {
        guard let gitUrl = URL(string: "https://github.com/FoxFromFuture/the-fripp-app") else { return }
        UIApplication.shared.open(gitUrl)
    }
}

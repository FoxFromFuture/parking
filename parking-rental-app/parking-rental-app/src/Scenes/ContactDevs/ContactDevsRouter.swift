//
//  ContactDevsRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/27/24.
//

import UIKit

final class ContactDevsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension ContactDevsRouter: ContactDevsRoutingLogic {
    func routeToMore() {
        self.view?.dismiss(animated: true)
    }
    
    func routeToGitHubLink() {
        guard let gitUrl = URL(string: "https://github.com/FoxFromFuture/parking") else { return }
        UIApplication.shared.open(gitUrl)
    }
}

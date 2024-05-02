//
//  NotAuthMoreRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/29/24.
//

import UIKit

final class NotAuthMoreRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension NotAuthMoreRouter: NotAuthMoreRoutingLogic {
    func routeToNotAuthSettings() {
        view?.navigationController?.pushViewController(NotAuthSettingsAssembly.build(), animated: true)
    }
    
    func routeToNotAuthContactDevs() {
        let vc = NotAuthContactDevsAssembly.build()
        vc.modalPresentationStyle = .overFullScreen
        view?.navigationController?.present(vc, animated: true)
    }
}

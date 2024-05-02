//
//  MoreRouter.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 3/9/24.
//

import UIKit

final class MoreRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension MoreRouter: MoreRoutingLogic {
    func routeToSettings() {
        view?.navigationController?.pushViewController(SettingsAssembly.build(), animated: true)
    }
    
    func routeToFAQ() {
        view?.navigationController?.pushViewController(FAQAssembly.build(), animated: true)
    }
    
    func routeToContactDevs() {
        let vc = ContactDevsAssembly.build()
        vc.modalPresentationStyle = .overFullScreen
        view?.navigationController?.present(vc, animated: true)
    }
}

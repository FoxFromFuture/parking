//
//  NotAuthTabBarController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

final class NotAuthTabBarController: UITabBarController {
    private enum TabBarItem: Int {
        case login
        case more
        
        var title: String {
            switch self {
            case .login:
                return "login".localize()
            case .more:
                return "more".localize()
            }
        }
        
        var iconName: String {
            switch self {
            case .login:
                return "house.fill"
            case .more:
                return "ellipsis.circle"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBar()
    }
    
    private func configureTabBar() {
        let dataSource: [TabBarItem] = [.login, .more]
        
        self.viewControllers = dataSource.map {
            switch $0 {
            case .login:
                let loginViewController = UINavigationController(
                    rootViewController: LoginAssembly.build()
                )
                loginViewController.title = $0.title
                loginViewController.tabBarItem.image = UIImage(systemName: $0.iconName, withConfiguration: UIImage.SymbolConfiguration(scale: .default))
                loginViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
                return loginViewController
            case .more:
                let notAuthMoreViewController = UINavigationController(
                    rootViewController: NotAuthMoreAssembly.build()
                )
                notAuthMoreViewController.title = $0.title
                notAuthMoreViewController.tabBarItem.image = UIImage(systemName: $0.iconName, withConfiguration: UIImage.SymbolConfiguration(scale: .default))
                notAuthMoreViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
                return notAuthMoreViewController
            }
        }
        
        UITabBar.appearance().backgroundColor = Colors.tabBar.uiColor
        UITabBar.appearance().tintColor = Colors.active.uiColor
    }
}

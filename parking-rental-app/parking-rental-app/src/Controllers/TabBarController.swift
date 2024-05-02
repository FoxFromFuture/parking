//
//  TabBarController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/30/24.
//

import UIKit

final class TabBarController: UITabBarController {
    private enum TabBarItem: Int {
        case home
        case more
        
        var title: String {
            switch self {
            case .home:
                return "home".localize()
            case .more:
                return "more".localize()
            }
        }
        
        var iconName: String {
            switch self {
            case .home:
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
        let dataSource: [TabBarItem] = [.home, .more]
        
        self.viewControllers = dataSource.map {
            switch $0 {
            case .home:
                let homeViewController = UINavigationController(
                    rootViewController: HomeAssembly.build()
                )
                homeViewController.title = $0.title
                homeViewController.tabBarItem.image = UIImage(systemName: $0.iconName, withConfiguration: UIImage.SymbolConfiguration(scale: .default))
                homeViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
                return homeViewController
            case .more:
                let moreViewController = UINavigationController(
                    rootViewController: MoreAssembly.build()
                )
                moreViewController.title = $0.title
                moreViewController.tabBarItem.image = UIImage(systemName: $0.iconName, withConfiguration: UIImage.SymbolConfiguration(scale: .default))
                moreViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
                return moreViewController
            }
        }
        
        UITabBar.appearance().backgroundColor = Colors.tabBar.uiColor
        UITabBar.appearance().tintColor = Colors.active.uiColor
    }
}

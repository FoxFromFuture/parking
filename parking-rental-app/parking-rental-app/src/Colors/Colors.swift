//
//  Colors.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/11/24.
//

import UIKit

enum Colors {
    case accent
    case active
    case background
    case danger
    case icon
    case mainText
    case secondaryText
    case tabBarTopBorder
    case tabBar
    case secondaryButton
    case multipleButtonsCardView
    case cardView
    case cardViewShadow
    case freeSpot
    case notFreeSpot
    case notAvailableSpot
    
    var uiColor: UIColor {
        switch self {
        case .accent:
            return UIColor(named: "AccentColor") ?? UIColor.systemYellow
        case .active:
            return UIColor(named: "Active") ?? UIColor.systemBlue
        case .background:
            return UIColor(named: "Background") ?? UIColor.white
        case .danger:
            return UIColor(named: "Danger") ?? UIColor.systemRed
        case .icon:
            return UIColor(named: "Icon") ?? UIColor.darkGray
        case .mainText:
            return UIColor(named: "MainText") ?? UIColor.black
        case .secondaryText:
            return UIColor(named: "SecondaryText") ?? UIColor.gray
        case .tabBarTopBorder:
            return UIColor(named: "TabBarTopBorder") ?? UIColor.lightGray
        case .tabBar:
            return UIColor(named: "TabBar") ?? UIColor.lightGray
        case .secondaryButton:
            return UIColor(named: "SecondaryButton") ?? UIColor.lightGray
        case .multipleButtonsCardView:
            return UIColor(named: "MultipleButtonsCardView") ?? UIColor.lightGray
        case .cardView:
            return UIColor(named: "CardView") ?? UIColor.white
        case .cardViewShadow:
            return UIColor(named: "CardViewShadow") ?? UIColor.black
        case .freeSpot:
            return UIColor(named: "FreeSpot") ?? UIColor.systemMint
        case .notFreeSpot:
            return UIColor(named: "NotFreeSpot") ?? UIColor.systemRed
        case .notAvailableSpot:
            return UIColor(named: "NotAvailableSpot") ?? UIColor.lightGray
        }
    }
}

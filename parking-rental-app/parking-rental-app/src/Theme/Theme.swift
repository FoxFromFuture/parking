//
//  Theme.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/10/24.
//

import UIKit

enum Theme: Int {
    case device = 0
    case light = 1
    case dark = 2
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    func str() -> String {
        switch self {
        case .device:
            return "device".localize()
        case .light:
            return "light".localize()
        case .dark:
            return "dark".localize()
        }
    }
}

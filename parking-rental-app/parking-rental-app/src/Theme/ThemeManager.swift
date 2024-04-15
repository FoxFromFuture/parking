//
//  ThemeManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/10/24.
//

import Foundation

final class ThemeManager {
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "theme")
        }
    }
}

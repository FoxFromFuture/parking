//
//  ThemeManager.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/10/24.
//

import Foundation

protocol ThemeManagerProtocol {
    var theme: Theme { get set }
}

final class ThemeManager: ThemeManagerProtocol {
    
    private var storage: UserDefaultsServiceProtocol!
    
    init(storage: UserDefaultsServiceProtocol = UserDefaultsService()) {
        self.storage = storage
    }
    
    var theme: Theme {
        get {
            Theme(rawValue: self.storage.theme) ?? .device
        }
        set {
            self.storage.theme = newValue.rawValue
        }
    }
}

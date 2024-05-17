//
//  UserDefaultsService.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/16/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case refreshTokenLastUpdateDate = "refreshTokenLastUpdateDate"
    case theme = "theme"
}

protocol UserDefaultsContainer {
    var date: Date? { get set }
    var theme: Int { get set }
}

class UserDefaultsService: UserDefaultsContainer {
    var date: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.refreshTokenLastUpdateDate.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.refreshTokenLastUpdateDate.rawValue)
        }
    }
    
    var theme: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.theme.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.theme.rawValue)
        }
    }
}

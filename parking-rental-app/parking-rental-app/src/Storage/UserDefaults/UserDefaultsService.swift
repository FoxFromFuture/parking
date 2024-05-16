//
//  UserDefaultsService.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 5/16/24.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    var date: Date? { get set }
    var theme: Int { get set }
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    private var userDefaultsContainer: UserDefaultsContainerProtocol

    init(userDefaultsContainer: UserDefaultsContainerProtocol = UserDefaultsContainer()) {
        self.userDefaultsContainer = userDefaultsContainer
    }

    var date: Date? {
        get {
            return userDefaultsContainer.date
        }
        set {
            userDefaultsContainer.date = newValue
        }
    }
    
    var theme: Int {
        get {
            return userDefaultsContainer.theme
        }
        set {
            userDefaultsContainer.theme = newValue
        }
    }
}

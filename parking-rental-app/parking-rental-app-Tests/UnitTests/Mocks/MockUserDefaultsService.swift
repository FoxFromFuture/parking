//
//  MockUserDefaultsService.swift
//  parking-rental-app-Tests
//
//  Created by Никита Лисунов on 5/16/24.
//

import Foundation
@testable import parking_rental_app

final class MockUserDefaultsService: UserDefaultsContainer {
    var date: Date?
    var theme: Int = Theme.device.rawValue
}

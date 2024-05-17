//
//  ThemeManagerUnitTests.swift
//  parking-rental-app-UnitTests
//
//  Created by Никита Лисунов on 5/16/24.
//

import XCTest
@testable import parking_rental_app

final class ThemeManagerUnitTests: XCTestCase {
    
    var themeManager: ThemeManagerProtocol!
    var storage: UserDefaultsContainer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        storage = MockUserDefaultsService()
        themeManager = ThemeManager(storage: storage)
    }

    override func tearDownWithError() throws {
        themeManager = nil
        storage = nil
        try super.tearDownWithError()
    }

    func testGetTheme() throws {
        // Arrange
        let theme = Theme.device
        storage.theme = theme.rawValue
        
        // Act
        let result = themeManager.theme
        
        // Assert
        XCTAssertEqual(result, theme)
    }
    
    func testSetTheme() throws {
        // Arrange
        let newTheme = Theme.dark
        storage.theme = Theme.device.rawValue
        
        // Act
        themeManager.theme = newTheme
        
        // Assert
        XCTAssertEqual(storage.theme, newTheme.rawValue)
    }
}

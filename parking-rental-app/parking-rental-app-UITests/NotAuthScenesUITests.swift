//
//  NotAuthScenesUITests.swift
//  parking-rental-app-UITests
//
//  Created by Никита Лисунов on 5/9/24.
//

import XCTest

final class NotAuthScenesUITests: XCTestCase {
    
    var appXC: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        appXC = XCUIApplication()
        appXC.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        appXC = nil
    }

    func testNotAuthMoreSceneAppearance() throws {
        // Arrange
        let tabBar = appXC.tabBars["Tab Bar"]
        let moreButton = tabBar.buttons["More"]
        let settings = appXC.staticTexts["Settings"]
        
        // Act
        moreButton.tap()
        
        // Assert
        XCTAssert(settings.exists)
    }
    
    func testRegistrationSceneAppearance() throws {
        // Arrange
        let registrationButton = appXC.buttons["Registration"]
        let registrationTitle = appXC.staticTexts["Registration"]
        
        // Act
        registrationButton.tap()
        
        // Assert
        XCTAssert(registrationTitle.exists)
    }
    
    func testNotAuthSettingsSceneAppearance() throws {
        // Arrange
        let tabBar = appXC.tabBars["Tab Bar"]
        let moreButton = tabBar.buttons["More"]
        let settingsButton = appXC.staticTexts["Settings"]
        let theme = appXC.staticTexts["Theme"]
        
        // Act
        moreButton.tap()
        settingsButton.tap()
        
        // Assert
        XCTAssert(theme.exists)
    }
    
    func testNotAuthContactDevsSceneAppearance() {
        // Arrange
        let tabBar = appXC.tabBars["Tab Bar"]
        let moreButton = tabBar.buttons["More"]
        let contactDevsButton = appXC.staticTexts["Contact developers"]
        let github = appXC.staticTexts["GitHub"]
        
        // Act
        moreButton.tap()
        contactDevsButton.tap()
        
        // Assert
        XCTAssert(github.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

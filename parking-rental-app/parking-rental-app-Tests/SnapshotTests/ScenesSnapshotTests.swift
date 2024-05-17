//
//  LoginSnapshotTests.swift
//  parking-rental-app-UnitTests
//
//  Created by Никита Лисунов on 5/16/24.
//

import XCTest
import iOSSnapshotTestCase
@testable import parking_rental_app

final class ScenesSnapshotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        fileNameOptions = [
            .OS,
            .device
        ]
        
        recordMode = false
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLoginView() throws {
        // Arrange
        let loginVC = LoginAssembly.build()
        
        // Assert
        FBSnapshotVerifyView(loginVC.view)
    }
    
    func testRegistrationView() {
        // Arrange
        let registrationVC = RegistrationAssembly.build()
        
        // Assert
        FBSnapshotVerifyView(registrationVC.view)
    }
    
    func testSplashView() {
        // Arrange
        let splashVC = SplashAssembly.build()
        
        // Assert
        FBSnapshotVerifyView(splashVC.view)
    }
    
    func testNotAuthMoreView() {
        // Arrange
        let notAuthMoreVC = NotAuthMoreAssembly.build()
        
        // Assert
        FBSnapshotVerifyView(notAuthMoreVC.view)
    }
    
    func testNotAuthSettingsView() {
        // Arrange
        let notAuthSettingsVC = NotAuthSettingsAssembly.build()
        
        // Assert
        FBSnapshotVerifyView(notAuthSettingsVC.view)
    }
    
    func testNotAuthContactDevsView() {
        // Arrange
        let notAuthContactDevs = NotAuthContactDevsAssembly.build()
        
        // Assert
        FBSnapshotVerifyView(notAuthContactDevs.view)
    }
}

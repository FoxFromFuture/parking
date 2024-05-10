//
//  LoginProcessUITests.swift
//  parking-rental-app-UITests
//
//  Created by Никита Лисунов on 5/10/24.
//

import XCTest
import SBTUITestTunnelClient

final class LoginProcessUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launchTunnel()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccesfulLogin() throws {
        // Arrange
        let match = SBTRequestMatch(url: "http://127.0.0.1:8080/auth/login")
        let stubId = app.stubRequests(matching: match, response: SBTStubResponse(response: ["type": "some", "accessToken": "some", "refreshToken": "some"]))
        let emailTextField = app.textFields["E-mail"]
        let passwordTextField = app.textFields["Password"]
        let enterButton = app.buttons["Enter"]
        let reserveLotButton = app.buttons["Reserve Lot"]
        
        // Act
        emailTextField.tap()
        app.buttons["shift"].tap()
        app.keys["a"].tap()
        app.keys["more"].tap()
        app.keys["@"].tap()
        app.keys["more"].tap()
        app.keys["a"].tap()
        app.keys["more"].tap()
        app.keys["."].tap()
        app.keys["more"].tap()
        app.keys["a"].tap()
        passwordTextField.tap()
        app.buttons["shift"].tap()
        app.keys["a"].tap()
        enterButton.tap()
        
        // Assert
        XCTAssert(reserveLotButton.exists)
    }
    
    func testLoginFailureAppearance() throws {
        // Arrange
        let match = SBTRequestMatch(url: "http://127.0.0.1:8080/auth/login")
        let stubId = app.stubRequests(matching: match, response: SBTStubFailureResponse(errorCode: URLError.notConnectedToInternet.rawValue))
        let emailTextField = app.textFields["E-mail"]
        let passwordTextField = app.textFields["Password"]
        let enterButton = app.buttons["Enter"]
        let failure = app.staticTexts["Incorrect e-mail or password"]
        
        // Act
        emailTextField.tap()
        app.buttons["shift"].tap()
        app.keys["n"].tap()
        app.keys["more"].tap()
        app.keys["@"].tap()
        app.keys["more"].tap()
        app.keys["a"].tap()
        app.keys["more"].tap()
        app.keys["."].tap()
        app.keys["more"].tap()
        app.keys["a"].tap()
        passwordTextField.tap()
        app.buttons["shift"].tap()
        app.keys["n"].tap()
        enterButton.tap()
        
        // Assert
        XCTAssert(failure.exists)
    }
}

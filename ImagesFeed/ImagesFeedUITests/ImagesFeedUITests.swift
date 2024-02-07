//
//  ImagesFeedUITests.swift
//  ImagesFeedUITests
//
//  Created by Lolita Chernysheva on 05.02.2024.
//  
//

import XCTest

final class ImagesFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {

        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews[AccessibilityIdentifiers.Views.webView]

        XCTAssertTrue(webView.waitForExistence(timeout: 5))


        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("EMAIL")
        
        webView.swipeUp()
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        passwordTextField.typeText("PASSWORD")
        webView.swipeUp()
        

        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 20))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)

        image.pinch(withScale: 3, velocity: 1)

        image.pinch(withScale: 0.5, velocity: -1)
        
        app.navigationBars["ImagesFeed.SingleImageView"]/*@START_MENU_TOKEN@*/.buttons["nav back button white"]/*[[".buttons[\"Back\"]",".buttons[\"nav back button white\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testProfile() throws {
        let app = XCUIApplication()
        let accountButton = XCUIApplication().tabBars["Tab Bar"].buttons["account"]

        accountButton.tap()
        
        XCTAssertTrue(app.staticTexts["FULL NAME"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["USER NAME"].waitForExistence(timeout: 5))
        
        app/*@START_MENU_TOKEN@*/.buttons["logout button"]/*[[".buttons[\"ipad.and.arrow.forward\"]",".buttons[\"logout button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.alerts["logoutAlert"].scrollViews.otherElements.buttons["Logout Yes"]/*[[".alerts[\"Пока, пока!\"].scrollViews.otherElements",".buttons[\"Да\"]",".buttons[\"Logout Yes\"]",".alerts[\"logoutAlert\"].scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
    }
}

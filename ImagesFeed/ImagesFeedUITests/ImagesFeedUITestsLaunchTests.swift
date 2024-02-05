//
//  ImagesFeedUITestsLaunchTests.swift
//  ImagesFeedUITests
//
//  Created by Lolita Chernysheva on 05.02.2024.
//  
//

import XCTest
@testable import ImagesFeed

final class ImagesFeedUITestsLaunchTests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    
    //Запуск приложения
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    // тестируем сценарий авторизации
    func testAuth() throws {
        // Нажать кнопку авторизации
        app.buttons[AccessibilityIdentifiers.Buttons.autnButton].tap()
        
        let webView = app.webViews[AccessibilityIdentifiers.Views.webView]
        
        // Подождать, пока экран авторизации открывается и загружается
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("<Ваш e-mail>")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("<Ваш пароль>")
        webView.swipeUp()
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {
        
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        // Поставить лайк в ячейке верхней картинки
        cellToLike.buttons["like button off"].tap()
        // Отменить лайк в ячейке верхней картинки
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        // Нажать на верхнюю ячейку
        cellToLike.tap()
        
        // Подождать, пока картинка открывается на весь экран
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1)
        
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        
        // Вернуться на экран ленты
        let navBackButtonWhiteButton = app.buttons[AccessibilityIdentifiers.Buttons.detailNavBackButton]
        navBackButtonWhiteButton.tap()
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        
        // Подождать, пока открывается и загружается экран ленты
        sleep(3)
        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        // Нажать кнопку логаута
        app.buttons[AccessibilityIdentifiers.Buttons.logoutButton].tap()
        // Проверить, что открылся экран авторизации
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons[AccessibilityIdentifiers.Buttons.logoutAlertYesButton].tap()
    }
}


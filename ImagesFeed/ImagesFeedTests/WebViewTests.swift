//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Lolita Chernysheva on 04.02.2024.
//  
//

import XCTest
@testable import ImagesFeed

class WebViewMock: WebViewProtocol {
    
    var lastRequest: URLRequest?
    var lastProgressValue: Float?
    var lastProgressIsHidden: Bool?
    
    func loadRequest(request: URLRequest) {
        lastRequest = request
    }
    
    func setProgressValue(_ newValue: Float) {
        lastProgressValue = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        lastProgressIsHidden = isHidden
    }
}

final class WebViewTests: XCTestCase {
    
    func testSetupURL() {
        let webViewMock = WebViewMock()
        let presenter = WebViewPresenter(view: webViewMock)
        
        presenter.setupURL()

        XCTAssertNotNil(webViewMock.lastRequest, "The loadRequest(request:) method was not called")
        
        XCTAssertEqual(webViewMock.lastRequest?.url?.absoluteString, "https://unsplash.com/oauth/authorize?client_id=\(AuthConfiguration.accessKey)&redirect_uri=\(AuthConfiguration.redirectURI)&response_type=code&scope=\(AuthConfiguration.accessScope)", "The request URL is not correct")
    }
    
    
    func testLoadRequest() {
        let webViewMock = WebViewMock()
        let presenter = WebViewPresenter(view: webViewMock)

        presenter.setupURL()

        guard let request = webViewMock.lastRequest else {
            XCTFail("loadRequest was not called")
            return
        }

        let expectedURLString = "https://unsplash.com/oauth/authorize?client_id=\(AuthConfiguration.accessKey)&redirect_uri=\(AuthConfiguration.redirectURI)&response_type=code&scope=\(AuthConfiguration.accessScope)"
        
        XCTAssertEqual(request.url?.absoluteString, expectedURLString, "loadRequest was called with incorrect URL")
    }
    
    func testDidUpdateProgressValue() {

        let webViewMock = WebViewMock()
        let presenter = WebViewPresenter(view: webViewMock)
        
        // Тестирование метода didUpdateProgressValue с прогрессом, который не должен быть скрыт
        presenter.didUpdateProgressValue(0.5)
        XCTAssertEqual(webViewMock.lastProgressValue, 0.5, "Progress value did not match")
        XCTAssertFalse(webViewMock.lastProgressIsHidden ?? true, "Progress should not be hidden")
        
        // Тестирование метода didUpdateProgressValue с прогрессом, который должен быть скрыт
        presenter.didUpdateProgressValue(1.0)
        XCTAssertEqual(webViewMock.lastProgressValue, 1.0, "Progress value did not match")
        XCTAssertTrue(webViewMock.lastProgressIsHidden ?? false, "Progress should be hidden")
    }
}

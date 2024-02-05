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
    
    func loadRequest(request: URLRequest) {
        lastRequest = request
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
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
}

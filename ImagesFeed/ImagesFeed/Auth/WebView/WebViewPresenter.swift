//
//  WebViewPresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 15.12.2023.
//  
//

import Foundation
import WebKit

protocol WebViewPresenterProtocol: AnyObject {
    func setupURL()
    func code(from navigationAction: WKNavigationAction) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    weak var view: WebViewProtocol?
    
    init(view: WebViewProtocol? = nil) {
        self.view = view
    }
    
    func setupURL() {
        guard let url = createAuthorizeURL() else {
            print("Невозможно создать URL")
            return
        }
        
        let request = URLRequest(url: url)
        view?.loadRequest(request: request)
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func createAuthorizeURL() -> URL? {
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        return urlComponents?.url
    }
}

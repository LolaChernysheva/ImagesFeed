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
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter {
    
    weak var view: WebViewProtocol?
    
    init(view: WebViewProtocol? = nil) {
        self.view = view
    }

    private func createAuthorizeURL() -> URL? {
        var urlComponents = URLComponents(string: AuthConfiguration.UnsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.accessKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AuthConfiguration.accessScope)
        ]
        
        return urlComponents?.url
    }
}

extension WebViewPresenter: WebViewPresenterProtocol {
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
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
}

private extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

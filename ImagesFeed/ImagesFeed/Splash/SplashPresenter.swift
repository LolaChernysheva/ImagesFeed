//
//  SplashPresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import UIKit

protocol SplashPresenterProtocol: AnyObject {
    func showNext()
    func fetchAuthToken(code: String)
}

final class SplashPresenter: SplashPresenterProtocol {
    
    weak var view: SplashViewProtocol?
    var coordinator: CoordinatorProtocol
    
    private let storage = OAuth2TokenStorage.shared
    private var oauth2Service = OAuth2Service.shared
    
    init(view: SplashViewProtocol?, coordinator: CoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func showNext() {
        guard let view else { return }
        if storage.hasToken() {
            coordinator.showMainTabbarController()
        } else {
            coordinator.showAuthController(delegate: view)
        }
    }
    
    func fetchAuthToken(code: String) {
        oauth2Service.fetchAuthToken(code: code) { [ weak self ] result in
            guard let self else { return }
            switch result {
            case let .success(token):
                oauth2Service.saveToken(token: token)
                showNext()
                view?.hideActivityIndicator()
            case let .failure(error):
                view?.showActivityIndicator()
                print(error.localizedDescription)
            }
        }
    }
}

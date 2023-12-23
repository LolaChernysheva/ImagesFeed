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
}

final class SplashPresenter: SplashPresenterProtocol {
    
    weak var view: SplashViewProtocol?
    var coordinator: CoordinatorProtocol
    
    private let storage = OAuth2TokenStorage.shared
    
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
}

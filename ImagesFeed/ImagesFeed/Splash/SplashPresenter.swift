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
    var coordinator: CoordinatorProtocol?
    
    private let storage = OAuth2TokenStorage.shared
    
    init(view: SplashViewProtocol?, coordinator: CoordinatorProtocol?) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func showNext() {
        if storage.hasToken() {
            if let view = view as? UIViewController {
                coordinator?.showImagesModule(view: view)
            }
        } else {
            if let view = view as? UIViewController {
                coordinator?.showAuthController(view: view)
            }
        }
    }
}

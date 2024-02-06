//
//  AuthPresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.12.2023.
//  
//

import UIKit

protocol AuthPresenterProtocol: AnyObject {
    func signIn()
    func setup()
}

final class AuthPresenter {
    
    weak var view: AuthViewProtocol?
    
    var coordinator: CoordinatorProtocol = CoordinatorManager.shared
    
    init(view: AuthViewProtocol, coordinator: CoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    private func buildScreenModel() -> AuthScreenModel {
        .init(
            backgroundColor: UIColor.ypBlack,
            buttonTitle: "Войти",
            buttonColor: UIColor.ypWhite,
            logoImage: UIImage(named: "Unsplash") ?? UIImage(),
            font: .boldSystemFont(ofSize: 17)
      )
    }
    
    private func render() {
        view?.displayData(data: buildScreenModel())
    }
    
}

extension AuthPresenter: AuthPresenterProtocol {
    func signIn() {
        if let view = view as? WebViewViewControllerDelegate {
            coordinator.showWebView(delegate: view)
        }
    }
    
    func setup() {
        render()
    }
}

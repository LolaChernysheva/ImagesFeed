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
    func fetchAuthToken(code: String)
}

final class AuthPresenter {
    
    weak var view: AuthViewProtocol?
    
    var coordinator: CoordinatorProtocol = CoordinatorManager.shared
    private var networkService = NetworkManager.shared
    
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
    
    func fetchAuthToken(code: String) {
        let requestModel = FetchTokenRequestModel(
            clientId: Constants.accessKey,
            clientSecret: Constants.secretKey,
            redirectUri: Constants.redirectURI,
            code: code,
            grantType: "authorization_code"
        )

        networkService.request(endpoint: .fetchToken, method: .POST, body: requestModel) { [weak self] (respnse: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch respnse {
            case let .success(result):
                DispatchQueue.main.async {
                    let storage = OAuth2TokenStorage.shared
                    storage.token = result.accessToken
                    if let view = self.view {
                        view.delegate?.authViewController(view, didAuthenticateWithToken:  result.accessToken)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

struct FetchTokenRequestModel: Codable {
    var clientId: String
    var clientSecret: String
    var redirectUri: String
    var code: String
    var grantType: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectUri = "redirect_uri"
        case code
        case grantType = "grant_type"
    }
}

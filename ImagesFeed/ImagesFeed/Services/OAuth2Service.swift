//
//  OAuth2Service.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 25.12.2023.
//  
//

import Foundation

typealias Token = String

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let networkService = NetworkManager.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private init(){}
    
    func fetchAuthToken(code: String, completion: @escaping (Result<Token, Error>) -> Void) {
        let requestModel = FetchTokenRequestModel(
            clientId: Constants.accessKey,
            clientSecret: Constants.secretKey,
            redirectUri: Constants.redirectURI,
            code: code,
            grantType: "authorization_code"
        )
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        task = networkService.request(endpoint: .fetchToken, method: .POST, body: .encodable(requestModel)) { [weak self] (respnse: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch respnse {
            case let .success(result):
                DispatchQueue.main.async {
                    completion(.success(result.accessToken))
                }
            case let .failure(error):
                print(error)
            }
            task = nil
        }
    }
    
    func saveToken(token: Token) {
        let storage = OAuth2TokenStorage.shared
        storage.token = token
    }
}

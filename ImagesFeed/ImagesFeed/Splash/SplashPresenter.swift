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
    private let storageService = StorageService.shared
    private var oauth2Service = OAuth2Service.shared
    private var service = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    
    init(view: SplashViewProtocol?, coordinator: CoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func showNext() {
        guard let view else { return }
        if storage.hasToken() {
            fetchUserInfo { [ weak self ] account in
                guard let self else { return }
                StorageService.shared.userProfile = account
                self.coordinator.showMainTabbarController()
            }
            
        } else {
            coordinator.showAuthController(delegate: view)
        }
    }

    func fetchAuthToken(code: String) {
        view?.showActivityIndicator()
        oauth2Service.fetchAuthToken(code: code) { [ weak self ] result in
            guard let self else { return }
            switch result {
            case let .success(token):
                oauth2Service.saveToken(token: token)
                showNext()
                view?.hideActivityIndicator()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUserInfo(completion: @escaping (_ account: AccoundData?) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        service.fetchProfile(token: token) { [ weak self ] profile in
            guard let self else { return }
            if let profile {
                self.profileImageService.fetchImage(userName: profile.userName) { result in
                    if let result {
                        let account = AccoundData(userName: profile.userName, fullName: profile.fullName, bio: profile.bio ?? "", avatar: result.profileImage.small)
                        completion(account)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

}

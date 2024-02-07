//
//  ProfilePresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func fetchUserInfo()
    func logout()
}

class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    private var coordinator: CoordinatorProtocol
    private var profileModel: ProfileModel = .empty
    
    init(view: ProfileViewProtocol?, coordinator: CoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    private func loadProfile() {
        view?.displayProfile(with: profileModel)
    }
    
    func fetchUserInfo() {
        guard let account = AccountData.shared.userProfile else { return }
        profileModel = .init(avatarString: account.avatar, fullName: account.fullName, nikName: account.userName, bio: account.bio)
        loadProfile()
    }
    
    func logout() {
        OAuth2TokenStorage.shared.removeTokenData()
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        coordinator.goToRootSplash()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didAcountDataChange),
            name: .didAccountDataChangeNotification,
            object: nil
        )
    }
   
   private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: .didAccountDataChangeNotification,
            object: nil
        )
    }
    
    @objc
    private func didAcountDataChange() {
        fetchUserInfo()
    }
}

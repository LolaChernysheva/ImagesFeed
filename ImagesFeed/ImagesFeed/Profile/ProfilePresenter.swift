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
}

class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    
    var profileModel: ProfileModel = .empty
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    private func loadProfile() {
        view?.displayProfile(with: profileModel)
    }
    
    func fetchUserInfo() {
        guard let account = StorageService.shared.userProfile else { return }
        profileModel = .init(avatarString: account.avatar, fullName: account.fullName, nikName: account.userName, bio: account.bio)
        loadProfile()
    }
}

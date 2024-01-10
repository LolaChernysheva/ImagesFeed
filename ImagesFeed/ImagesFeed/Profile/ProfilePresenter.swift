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
    
    private var service = ProfileService.shared
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    private func loadProfile(profileModel: ProfileModel) {
        view?.displayProfile(with: profileModel)
    }
    
    func fetchUserInfo() {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        service.fetchProfile(token) { [ weak self ] result in
            guard let self else { return }
            switch result {
            case let .success(profile):
                DispatchQueue.main.async {
                    let profileModel: ProfileModel = .init(fullName: "\(profile.firstName) \(profile.lastName)", nikName: profile.userName, bio: profile.bio ?? "" )
                    self.loadProfile(profileModel: profileModel)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
}

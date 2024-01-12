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
    private var profileImageService = ProfileImageService.shared
    weak var view: ProfileViewProtocol?
    
    var profileModel: ProfileModel = .empty
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    private func loadProfile() {
        view?.displayProfile(with: profileModel)
    }
    
    func fetchUserInfo() {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        fetchProfile(token: token) { [ weak self ] profile in
            guard let self else { return }
            if let profile {
                fetchImage(userName: profile.userName) { result in
                    if let result {
                        self.profileModel = .init(avatarString: result.profileImage.small, fullName: profile.fullName, nikName: profile.userName, bio: profile.bio ?? "")
                        DispatchQueue.main.async {
                            self.loadProfile()
                        }
                    }
                }
            }
        }
    }

    private func fetchProfile(token: String,  completion: @escaping (ProfileResponceModel?) -> Void) {
        service.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(profile):
                completion(profile)
            case let .failure(error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    private func fetchImage(userName: String, completion: @escaping (UserResult?) -> Void) {
        profileImageService.fetchProfileImageURL(username: userName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                completion(result)
            case let .failure(error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

//
//  ProfileImageService.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 11.01.2024.
//  
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let networkService = NetworkManager.shared
    private (set) var avatarURL: String?
    
    private init() {}
    
    private func fetchProfileImageURL(username: String, _ completion: @escaping (Result<UserResult, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let headers = ["Authorization": "Bearer \(token)"]
        networkService.request(endpoint: .fetchUserAvatar(userName: username), method: .GET, body: nil, headers: headers) { [ weak self ] (response: Result<UserResult, Error>) in
            guard let self else { return }
            switch response {
            case let .success(result):
                DispatchQueue.main.async {
                    self.avatarURL = result.profileImage.small
                    completion(.success(result))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchImage(userName: String, completion: @escaping (UserResult?) -> Void) {
        fetchProfileImageURL(username: userName) { [weak self] result in
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


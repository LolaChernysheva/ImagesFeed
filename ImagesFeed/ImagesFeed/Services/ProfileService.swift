//
//  ProfileService.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 03.01.2024.
//  
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let networkService = NetworkManager.shared
    private init(){}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResponceModel, Error>) -> Void) {
        let headers = ["Authorization": "Bearer \(token)"]
        networkService.request(
            endpoint: .fetchUserInfo,
            method: .GET,
            headers: headers
        ) { [ weak self ] (response: Result<ProfileResponceModel, Error>) in
            switch response {
            case let .success(result):
                print("===\(result)")
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            case let .failure(error):
                print("====\(error.localizedDescription)")
                
            }
        }
    }
    
}

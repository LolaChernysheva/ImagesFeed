//
//  EndpointManager.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import Foundation

enum EndpointManager {
    static let baseUrl = "https://unsplash.com"
    
    case fetchData
    case fetchToken
    case fetchUserInfo
    case fetchUserAvatar(userName: String)
    case fetchPhotos
    case changeLike(photoId: String)

    var urlString: String {
        switch self {
        case .fetchData:
            return "\(Self.baseUrl)/fetch"
        case .fetchToken:
            return "https://unsplash.com/oauth/token"
        case .fetchUserInfo:
            return "https://api.unsplash.com/me"
        case let .fetchUserAvatar(userName):
            return "https://api.unsplash.com/users/\(userName)"
        case .fetchPhotos:
            return "https://api.unsplash.com/photos"
        case let .changeLike(photoId):
            return "https://api.unsplash.com/photos/\(photoId)/like"
        }
    }
}


//
//  EndpointManager.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import Foundation

enum EndpointManager {
    static let baseUrl = "https://example.com/api"
    
    case fetchData
    case postData(roomId: String)
    case fetchToken

    var urlString: String {
        switch self {
        case .fetchData:
            return "\(Self.baseUrl)/fetch"
        case let .postData(roomId):
            return "https://example.com/api/post/\(roomId)"
        case .fetchToken:
            return "https://unsplash.com/oauth/token"
        }
    }
    
    
}


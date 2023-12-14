//
//  Unsplash.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.12.2023.
//  
//

import Foundation

struct Unsplash: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

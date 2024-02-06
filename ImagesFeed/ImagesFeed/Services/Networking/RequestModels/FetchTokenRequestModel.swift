//
//  FetchTokenRequestModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 25.12.2023.
//  
//

import Foundation

struct FetchTokenRequestModel: Codable {
    var clientId: String
    var clientSecret: String
    var redirectUri: String
    var code: String
    var grantType: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectUri = "redirect_uri"
        case code
        case grantType = "grant_type"
    }
}

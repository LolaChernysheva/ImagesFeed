//
//  ProfileResponceModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 03.01.2024.
//  
//

import Foundation

struct ProfileResponceModel: Codable {
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

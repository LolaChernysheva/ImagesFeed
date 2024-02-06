//
//  ProfileModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit

struct ProfileModel {
    var avatarString: String? = nil
    let fullName: String
    let nikName: String
    let bio: String
    
    static let empty: ProfileModel = ProfileModel(fullName: "", nikName: "", bio: "")
    
}

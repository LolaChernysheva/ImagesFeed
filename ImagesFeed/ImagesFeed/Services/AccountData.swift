//
//  AccountData.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.01.2024.
//  
//

import Foundation

final class AccountData {
    
    static let shared = AccountData()
    
    private init() {}
    
    var userProfile: AccoundData? {
        didSet {
            didAccountDataChange()
        }
    }
    
    func didAccountDataChange() {
        NotificationCenter.default
            .post(
                name: .didAccountDataChangeNotification,
                object: self,
                userInfo: [:]
            )
    }
}

extension Notification.Name {
    
    static let didAccountDataChangeNotification = Notification.Name(rawValue: "AccountDataDidChange") // ProfileImageProviderDidChange
}

struct AccoundData: Codable {
    var userName: String
    var fullName: String
    var bio: String
    var avatar: String
}


//
//  OAuth2TokenStorage.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let tokenKey = "BearerToken"
    
    private init() {}

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            }
        }
    }
    
    func hasToken() -> Bool {
        return KeychainWrapper.standard.hasValue(forKey: tokenKey)
    }
}

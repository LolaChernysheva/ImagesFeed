//
//  StorageService.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.01.2024.
//  
//

import Foundation

final class StorageService {
    
    static let shared = StorageService()
    
    private init() {}
    
    var userProfile: AccoundData? {
        get {
            if let encodedData = UserDefaults.standard.data(forKey: "userProfileKey") {
                do {
                    let decoder = JSONDecoder()
                    let userProfile = try decoder.decode(AccoundData.self, from: encodedData)
                    return userProfile
                } catch {
                    print("Error decoding user profile: \(error)")
                }
            }
            return nil
        }
        set {
            do {
                let encoder = JSONEncoder()
                let encodedData = try encoder.encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: "userProfileKey")
            } catch {
                print("Error encoding user profile: \(error)")
            }
        }
    }
}

struct AccoundData: Codable {
    var userName: String
    var fullName: String
    var bio: String
    var avatar: String
}


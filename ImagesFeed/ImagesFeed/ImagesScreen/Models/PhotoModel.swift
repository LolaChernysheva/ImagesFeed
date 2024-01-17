//
//  PhotoModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 16.01.2024.
//  
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}


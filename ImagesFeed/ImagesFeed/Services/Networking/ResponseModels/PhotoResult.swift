//
//  PhotoResult.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 16.01.2024.
//  
//

import Foundation

struct PhotosResponce: Codable {
    let photos: [PhotoResult]
}

struct PhotoLikeResponce: Codable {
    let photo: PhotoResult
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likes: Int
    let isLiked: Bool
    let user: UserResult
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, description, likes
        case isLiked = "liked_by_user"
        case user, urls
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}


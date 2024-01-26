//
//  ImagesListService.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 16.01.2024.
//  
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    //MARK: TODO - check format
    
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
        return formatter
    }()

    private let networkManager = NetworkManager.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private var photosCount = 10
    
    private init(){}
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        let headers = ["Authorization": "Bearer \(token)"]
        let params = [
            "page": String(lastLoadedPage ?? 1),
            "per_page": String(photosCount)
        ]
        if self.task != nil {
            return
        }
        task = networkManager.request(
            endpoint: .fetchPhotos,
            method: .GET,
            headers: headers,
            queryParameters: params
        ) { [ weak self ] (response: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch response {
            case let .success(result):
                let nextPage = lastLoadedPage == nil
                ? 1
                : lastLoadedPage! + 1
                completion(.success(result))
                self.lastLoadedPage = nextPage
            case let .failure(error):
                completion(.failure(error))
            }
            task = nil
        }
    }
}

extension Notification.Name {
    static let imagesListServiceDidChange = Notification.Name(rawValue: "ImagesListServiceDidChange")
}

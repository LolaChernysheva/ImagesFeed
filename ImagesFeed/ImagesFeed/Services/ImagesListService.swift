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
    
    private (set) var photos: [Photo] = []
    private let networkManager = NetworkManager.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
    private init(){}
    
    func fetchPhotosNextPage() {
        networkManager.request(
            endpoint: .fetchPhotos,
            method: .GET) { [ weak self ] (response: Result<PhotosResponce, Error>) in
                
                guard let self else { return }
                
                if self.task != nil {
                    return
                }

                switch response {
                case let .success(result):
                    let nextPage = lastLoadedPage == nil
                        ? 1
                        : lastLoadedPage! + 1
                    DispatchQueue.main.async {
                        let newPhotos = result.photos.map {
                            Photo(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: Self.dateFormatter.date(from: $0.createdAt),
                                welcomeDescription: $0.description,
                                thumbImageURL: $0.urls.thumb,
                                largeImageURL: $0.urls.full,
                                isLiked: $0.isLiked
                            )
                        }
                        self.photos += newPhotos
                        self.lastLoadedPage = nextPage
                        NotificationCenter.default
                            .post(
                                name: .imagesListServiceDidChange,
                                object: self,
                                userInfo: [:]
                            )
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
}

extension Notification.Name {
    static let imagesListServiceDidChange = Notification.Name(rawValue: "ImagesListServiceDidChange")
}

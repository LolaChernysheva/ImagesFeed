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
    
    func changeLike(photoId: String, isLike: Bool, _completion: @escaping (Result<PhotoResult, Error>)-> Void) {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let headers = ["Authorization": "Bearer \(token)"]
        networkManager.request(
            endpoint: .changeLike(photoId: photoId),
            method: isLike ? .DELETE : .POST,
            headers: headers) { (response: Result<PhotoResult, Error>) in
                switch response {
                case let .success(response):
                    _completion(.success(response))
                case let.failure(error):
                    _completion(.failure(error))
                }
            }
    }
}

extension Notification.Name {
    static let imagesListServiceDidChange = Notification.Name(rawValue: "ImagesListServiceDidChange")
}

//
//  ImagesListPresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 15.11.2023.
//  
//

import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewProtocol? { get }
    var photos: [Photo] { get }
    func setup()
    func fetchPhotosNextPage()
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    
    typealias TableData = ImagesListScreenModel.TableData
    
    private (set) var photos: [Photo] = []

    private lazy var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()

    private lazy var displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    weak var view: ImagesListViewProtocol?
    var coordinator: CoordinatorProtocol?
    private let imagesService = ImagesListService.shared
    
    init(view: ImagesListViewProtocol?, coordinator: CoordinatorProtocol?) {
        self.view = view
        self.coordinator = coordinator
    }
    
    private func buildScreenModel() -> ImagesListScreenModel {
        
        let cells: [ImagesListScreenModel.TableData.Cell] = photos.map { photo in
            let isoString = isoFormatter.string(from: photo.createdAt ?? Date())
            let isoDate = isoFormatter.date(from: isoString)
            let dateString = displayDateFormatter.string(from: isoDate ?? Date())
            let cellModel = ImageCellViewModel(
                imageString: photo.largeImageURL,
                dateString: dateString,
                likeImageName: photo.isLiked ? "Active" :  "No Active",
                completion: { [ weak self ] in
                    guard let self = self else { return }
                    self.coordinator?.showDetail(forImageNamed: photo.largeImageURL)
                },
                likeAction: {
                    DispatchQueue.global().async {
                        self.imagesService.changeLike(photoId: photo.id, isLike: photo.isLiked) { response in
                            switch response {
                            case let .success(photo):
                                DispatchQueue.main.async {
                                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                                        let photo = self.photos[index]
                                        let newPhoto = Photo(
                                            id: photo.id,
                                            size: photo.size,
                                            createdAt: photo.createdAt,
                                            welcomeDescription: photo.welcomeDescription,
                                            thumbImageURL: photo.thumbImageURL,
                                            largeImageURL: photo.largeImageURL,
                                            isLiked: !photo.isLiked
                                        )
                                        self.photos = self.photos.withReplaced(index: index, newValue: newPhoto)
                                        self.render()
                                    }
                                }
                            case let .failure(error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                })
            return .imageCell(cellModel)
        }
        return .init(
            tableData: .init(sections: [.simpleSection(cells: cells)]), backbroundColor: UIColor.ypBlack)
    }
    
    private func render(reloadTableData: Bool = true) {
        view?.displayData(data: buildScreenModel(), reloadData: reloadTableData)
    }
    
    //MARK: - ImagesListPresenterProtocol

    func setup() {
        fetchPhotosNextPage()
        render()
    }
    
    func fetchPhotosNextPage() {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        DispatchQueue.global().async { [imagesService] in
            imagesService.fetchPhotosNextPage(token) { [weak self] responce in
                guard let self else { return }
                switch responce {
                case let .success(photos):
                    DispatchQueue.main.async {
                        let newPhotos = photos.map {
                            let isoDate = self.isoFormatter.date(from: $0.createdAt)
                            let dateString = self.displayDateFormatter.string(from: isoDate ?? Date())
                            return Photo(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: self.displayDateFormatter.date(from: dateString),
                                welcomeDescription: $0.description,
                                thumbImageURL: $0.urls.thumb,
                                largeImageURL: $0.urls.small,
                                isLiked: $0.isLiked
                            )
                        }
                        self.photos += newPhotos
                        NotificationCenter.default
                            .post(
                                name: .imagesListServiceDidChange,
                                object: self,
                                userInfo: [:]
                            )
                        self.render(reloadTableData: true)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

fileprivate extension Array {
    func withReplaced(index: Int, newValue: Element) -> [Element] {
        var modifiedArray = self
        if index >= 0 && index < count {
            modifiedArray[index] = newValue
        }
        return modifiedArray
    }
}

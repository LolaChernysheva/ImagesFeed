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

    weak var view: ImagesListViewProtocol?
    var coordinator: CoordinatorProtocol?
    private let imagesService = ImagesListService.shared
    
    private var photosIdInLikeProgress: Set<String> = []
    
    init(view: ImagesListViewProtocol?, coordinator: CoordinatorProtocol?) {
        self.view = view
        self.coordinator = coordinator
    }
    
    private func buildScreenModel() -> ImagesListScreenModel {
        
        let cells: [ImagesListScreenModel.TableData.Cell] = photos.map { photo in
            let photoId = photo.id
            let cellModel = ImageCellViewModel(
                imageString: photo.largeImageURL,
                size: photo.size,
                dateString: (photo.createdAt ?? Date()).makeDisplayString(),
                likeImageName: photo.isLiked ? "Active" :  "No Active",
                completion: { [ weak self ] in
                    guard let self = self else { return }
                    self.coordinator?.showDetail(forImageNamed: photo.largeImageURL)
                },
                likeAction: { [weak self] in
                    self?.likeAction(photoId: photoId, isLiked: photo.isLiked)
                }, 
                isLikeBtnEnabled: !photosIdInLikeProgress.contains(photoId))
            return .imageCell(cellModel)
        }
        return .init(
            tableData: .init(sections: [.simpleSection(cells: cells)]), backbroundColor: UIColor.ypBlack)
    }
    
    private func render(reloadTableData: Bool = false) {
        view?.displayData(data: buildScreenModel(), reloadData: reloadTableData)
    }
    
    //MARK: - ImagesListPresenterProtocol

    func setup() {
        fetchPhotosNextPage()
        render()
    }
    
    func fetchPhotosNextPage() {
        guard let token = OAuth2TokenStorage.shared.token else { return }
        view?.showActivityIndicator()
        DispatchQueue.global().async { [imagesService] in
            imagesService.fetchPhotosNextPage(token) { [weak self] responce in
                guard let self else { return }
                switch responce {
                case let .success(photos):
                    DispatchQueue.main.async {
                        let newPhotos = photos.map { $0.convertToPhoto() }
                        self.photos += newPhotos
                        NotificationCenter.default
                            .post(
                                name: .imagesListServiceDidChange,
                                object: self,
                                userInfo: [:]
                            )
                        self.render(reloadTableData: true)
                    }
                    view?.hideActivityIndicator()
                case let .failure(error):
                    print(error.localizedDescription)
                    view?.hideActivityIndicator()
                }
            }
        }
    }
}

private extension ImagesListPresenter {
    
    func likeAction(photoId: String, isLiked: Bool) {
        guard !photosIdInLikeProgress.contains(photoId) else { return }
        photosIdInLikeProgress.insert(photoId)
        render(reloadTableData: true)
        DispatchQueue.global().async {
            self.imagesService.changeLike(photoId: photoId, isLike: isLiked) { response in
                switch response {
                case let .success(response):
                    DispatchQueue.main.async { [weak self] in
                        guard let self, let index = self.photos.firstIndex(where: { $0.id == photoId}) else { return }
                        photosIdInLikeProgress.remove(photoId)
                        let newPhoto = response.photo.convertToPhoto()
                        self.photos = self.photos.withReplaced(index: index, newValue: newPhoto)
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

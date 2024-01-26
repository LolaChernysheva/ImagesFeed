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
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
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
            let cellModel = ImageCellViewModel(
                imageString: photo.largeImageURL,
                dateString: dateFormatter.string(from: photo.createdAt ?? Date()),
                likeImageName: photo.isLiked ? "Active" :  "No Active",
                completion: { [ weak self ] in
                    guard let self = self else { return }
                    self.coordinator?.showDetail(forImageNamed: photo.largeImageURL)
                },
                likeAction: {
                    //MARK: - TODO
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
                            Photo(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: self.dateFormatter.date(from: $0.createdAt),
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

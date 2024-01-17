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
    
    var photos: [Photo] = []
    private let imagesService = ImagesListService.shared
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    weak var view: ImagesListViewProtocol?
    var coordinator: CoordinatorProtocol?
    
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
        render()
    }
    
    func fetchPhotosNextPage() {
        imagesService.fetchPhotosNextPage()
    }
}

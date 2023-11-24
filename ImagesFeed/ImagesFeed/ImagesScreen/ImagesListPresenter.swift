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
    func setup()
    
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    
    typealias TableData = ImagesListScreenModel.TableData
    
    private let photosNames: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    weak var view: ImagesListViewProtocol?
    
    init(view: ImagesListViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> ImagesListScreenModel {
        let cells: [ImagesListScreenModel.TableData.Cell] = photosNames.enumerated().map { index, imageName in
            let likeImageName = index % 2 == 0 ? "No Active" : "Active"
            let cellViewModel = ImageCellViewModel(
                imageName: imageName,
                text: dateFormatter.string(from: Date()) ,
                likeImageName: likeImageName,
                action: {
                    //MARK: - TODO
                }, likeAction: {
                    //MARK: - TODO
                })
            return .imageCell(cellViewModel)
        }
        
        return .init(
            tableData: .init(sections: [ .simpleSection(cells: cells)]),
            backbroundColor: UIColor.ypBlack
            )
    }
    
    private func render(reloadTableData: Bool = true) {
        view?.displayData(data: buildScreenModel(), reloadData: reloadTableData)
    }
    
    
    //MARK: - ImagesListPresenterProtocol

    func setup() {
        render()
    }
}

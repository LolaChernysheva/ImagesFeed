//
//  SingleImagePresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 12.12.2023.
//  
//

import UIKit

protocol SingleImagePresenterProtocol: AnyObject {
    var view: SingleImageViewProtocol? { get }
    func setup()
    func shareButtonTapped()
}

final class SingleImagePresenter {
    
    weak var view: SingleImageViewProtocol?
    var model: SingleImageScreenModel = .empty
    var imageName: String
    
    init(view: SingleImageViewProtocol?, imageName: String) {
        self.view = view
        self.imageName = imageName
    }
    
    private func buildScreenModel() -> SingleImageScreenModel {
        .init(
            imageName: imageName,
            sharedImageName: "Sharing"
        )
    }

    private func render() {
        view?.displayData(data: buildScreenModel())
    }
    
}

extension SingleImagePresenter: SingleImagePresenterProtocol {
    func setup() {
        render()
    }
    
    func shareButtonTapped() {
        view?.showActivityController()
    }
}

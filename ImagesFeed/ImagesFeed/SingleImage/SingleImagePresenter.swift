//
//  SingleImagePresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 12.12.2023.
//  
//

import UIKit

protocol SingleImagePresenterProtocol: AnyObject {
    init(view: SingleImageViewProtocol, model: SingleImageScreenModel)
    func viewDidLoad()
    func shareButtonTapped()
}

final class SingleImagePresenter: SingleImagePresenterProtocol {
    
    weak var view: SingleImageViewProtocol?
    var model: SingleImageScreenModel
    
    required init(view: SingleImageViewProtocol, model: SingleImageScreenModel) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view?.displayImage(named: model.imageName)
    }
    
    func shareButtonTapped() {
        view?.showActivityController()
    }
}

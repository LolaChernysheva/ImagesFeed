//
//  ProfilePresenter.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func loadProfile()
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var model: ProfileModel?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    func loadProfile() {
        let profileModel = ProfileModel(avatarString: "Pixel",
                                        fullName: "Екатерина Новикова",
                                        nikName: "@ekaterina_nov",
                                        bio: "Hello, world!")
        view?.displayProfile(with: profileModel)
    }
    
}

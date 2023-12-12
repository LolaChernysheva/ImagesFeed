//
//  Assembler.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit

final class Assembler {
    
    static func createProfileModule() -> UIViewController {
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenter(view: profileViewController)
        profileViewController.presenter = presenter
        return profileViewController
    }

    static func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let profileViewController = createProfileModule()
        let imagesViewController = createImagesModule()
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(systemName: "person.crop.circle"),
                                                        selectedImage: UIImage(systemName: " person.crop.circle.fill"))
        imagesViewController.tabBarItem = UITabBarItem( title: nil,
                                                        image: UIImage(systemName: "square.stack"),
                                                        selectedImage: UIImage(systemName: "square.stack.fill"))
        tabBarController.tabBar.tintColor = UIColor.ypWhite
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.viewControllers = [imagesViewController, profileViewController]

        return tabBarController
    }
    
    static func createImagesModule() -> UIViewController {
        let imagesViewController = ImagesListViewController()
        let navigationController = UINavigationController(rootViewController: imagesViewController)
        let coordinator = MainCoordinator(navigationController: navigationController)
        let presenter = ImagesListPresenter(view: imagesViewController, coordinator: coordinator)
        imagesViewController.presenter = presenter
        return navigationController
    }
    
    static func createSingleImegeModule(withImageNamed imageName: String) -> UIViewController {
        let singleImageController = SingleImageViewController()
        return singleImageController
    }
}

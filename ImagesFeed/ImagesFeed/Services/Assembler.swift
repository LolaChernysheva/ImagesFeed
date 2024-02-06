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
        let coordinator = CoordinatorManager.shared
        let presenter = ProfilePresenter(view: profileViewController, coordinator: coordinator)
        profileViewController.presenter = presenter
        return profileViewController
    }

    static func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let profileViewController = createProfileModule()
        let imagesViewController = createImagesModule()
        let nc = UINavigationController(rootViewController: imagesViewController)
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(systemName: "person.crop.circle"),
                                                        selectedImage: UIImage(systemName: " person.crop.circle.fill"))
        nc.tabBarItem = UITabBarItem( title: nil,
                                                        image: UIImage(systemName: "square.stack"),
                                                        selectedImage: UIImage(systemName: "square.stack.fill"))
        tabBarController.tabBar.tintColor = UIColor.ypWhite
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.viewControllers = [nc, profileViewController]

        return tabBarController
    }
    
    static func createImagesModule() -> UIViewController {
        let imagesViewController = ImagesListViewController()
        let coordinator = CoordinatorManager.shared
        let presenter = ImagesListPresenter(view: imagesViewController, coordinator: coordinator)
        imagesViewController.presenter = presenter
        return imagesViewController
    }
    
    static func createSingleImegeModule(withImageNamed imageName: String) -> UIViewController {
        let detailViewController = SingleImageViewController()
        let presenter = SingleImagePresenter(view: detailViewController, imageName: imageName)
        detailViewController.presenter = presenter
        detailViewController.hidesBottomBarWhenPushed = true
        return detailViewController
    }
    
    static func createAuthController(delegate: AuthViewControllerDelegate) -> UIViewController {
        let authController = AuthViewController(delegate: delegate)
        let coordinator = CoordinatorManager.shared
        let presenter = AuthPresenter(view: authController, coordinator: coordinator)
        authController.presenter = presenter
        return authController
    }
    
    static func createWebViewModule(delegate: WebViewViewControllerDelegate) -> UIViewController {
        let webView = WebViewViewController()
        let presenter = WebViewPresenter(view: webView)
        webView.presenter = presenter
        webView.delegate = delegate
        webView.modalPresentationStyle = .fullScreen
        return webView
    }
    
    static func createSplashModule() -> UIViewController {
        let splashController = SplashViewController()
        let coordinator = CoordinatorManager.shared
        let presenter = SplashPresenter(view: splashController, coordinator: coordinator)
        splashController.presenter = presenter
        return splashController
    }
}

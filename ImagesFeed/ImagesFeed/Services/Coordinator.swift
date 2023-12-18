//
//  Coordinator.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit

protocol CoordinatorProtocol {
    func showDetail(forImageNamed imageName: String)
    func showWebView(delegate: WebViewViewControllerDelegate)
    func showImagesModule(view: UIViewController)
    func showAuthController()
}

final class MainCoordinator: CoordinatorProtocol {
    func showDetail(forImageNamed imageName: String) {
        let detailViewController = Assembler.createSingleImegeModule(withImageNamed: imageName)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showWebView(delegate: WebViewViewControllerDelegate) {
        let webView = Assembler.createWebViewModule(delegate: delegate)
        let navigationController = UINavigationController(rootViewController: webView)
        navigationController.pushViewController(webView, animated: true)
    }
    
    func showImagesModule(view: UIViewController) {
        let imagesVC = Assembler.createTabBarController()
        imagesVC.modalPresentationStyle = .fullScreen
        view.present(imagesVC, animated: true)
    }
    
    func showAuthController() {
        let authController = Assembler.createAuthController()
        authController.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: authController)
        navigationController.pushViewController(authController, animated: true)
    }
}

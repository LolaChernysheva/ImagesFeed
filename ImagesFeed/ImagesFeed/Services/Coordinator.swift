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
    func showWebView(delegate: WebViewViewControllerDelegate, view: UIViewController)
    func showImagesModule(view: UIViewController)
    func showAuthController(view: UIViewController)
}

final class MainCoordinator: CoordinatorProtocol {
    func showDetail(forImageNamed imageName: String) {
        let detailViewController = Assembler.createSingleImegeModule(withImageNamed: imageName)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showWebView(delegate: WebViewViewControllerDelegate, view: UIViewController) {
        let webView = Assembler.createWebViewModule(delegate: delegate)
        view.navigationController?.pushViewController(webView, animated: true)
    }
    
    func showImagesModule(view: UIViewController) {
        let imagesVC = Assembler.createTabBarController()
        imagesVC.modalPresentationStyle = .fullScreen
        view.present(imagesVC, animated: true)
    }
    
    func showAuthController(view: UIViewController) {
        let authController = Assembler.createAuthController()
        let navigationController = UINavigationController(rootViewController: authController)
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true)
    }
}

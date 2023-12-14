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
    func showWebView()
}

final class MainCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetail(forImageNamed imageName: String) {
        let detailViewController = SingleImageViewController()
        let presenter = SingleImagePresenter(view: detailViewController, imageName: imageName)
        detailViewController.presenter = presenter
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showWebView() {
        let webView = WebViewViewController()
        webView.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(webView, animated: true)
    }
}

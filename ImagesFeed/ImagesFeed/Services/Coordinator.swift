//
//  Coordinator.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 30.11.2023.
//  
//

import UIKit

protocol CoordinatorProtocol {
    
    func start(window: UIWindow)
    func showMainTabbarController()
    func showDetail(forImageNamed imageName: String)
    func showWebView(delegate: WebViewViewControllerDelegate)
    func showAuthController(delegate: AuthViewControllerDelegate)
}

class CoordinatorManager {
    
    static let shared = MainCoordinator()

    private init() {}
}

final class MainCoordinator: CoordinatorProtocol {
    
    private var window: UIWindow!
    private var rootViewController: UIViewController = UINavigationController() {
        didSet {
            if let window {
                window.rootViewController = rootViewController
                window.makeKeyAndVisible()
            }
        }
    }
    private var splashViewController: UIViewController?

    func start(window: UIWindow) {
        self.window = window
        window.rootViewController = rootViewController
        showSplashScreen()
    }

    private func showSplashScreen() {
        let splashVC = Assembler.createSplashModule()
        splashViewController = splashVC
        rootViewController = splashVC
    }
}

extension MainCoordinator {
    
    func showMainTabbarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = Assembler.createTabBarController()
        splashViewController = nil
        rootViewController = tabBarController
    }
    
    func showDetail(forImageNamed imageName: String) {
        let detailViewController = Assembler.createSingleImegeModule(withImageNamed: imageName)
        detailViewController.modalPresentationStyle = .fullScreen
        ((rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController)?.pushViewController(detailViewController, animated: true)
    }
    
    func showWebView(delegate: WebViewViewControllerDelegate) {
        let webView = WebViewViewController()
        let presenter = WebViewPresenter(view: webView)
        webView.presenter = presenter
        webView.delegate = delegate
        webView.modalPresentationStyle = .fullScreen
        (rootViewController as? UINavigationController)?.pushViewController(webView, animated: true)
    }
    
    func showAuthController(delegate: AuthViewControllerDelegate) {
        let authController = Assembler.createAuthController(delegate: delegate)
        let navigationController = UINavigationController(rootViewController: authController)
        navigationController.modalPresentationStyle = .fullScreen
        rootViewController = navigationController
    }
}

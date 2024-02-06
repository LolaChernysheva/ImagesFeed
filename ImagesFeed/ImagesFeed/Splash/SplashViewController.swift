//
//  SplashViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import UIKit
import ProgressHUD

protocol SplashViewProtocol: UIViewController, AuthViewControllerDelegate {
    func showActivityIndicator()
    func hideActivityIndicator()
    func showErrorAlert()
}

final class SplashViewController: UIViewController, SplashViewProtocol {

    var presenter: SplashPresenterProtocol!
    private var logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.showNext()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.ypDarkBackground
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "Vector")
        setupLogoConstraints()
    }
    
    private func setupLogoConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: .logoWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: .logoHeight)
        ])
    }
    
    func showActivityIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showErrorAlert() {
        guard let vc = UIApplication.getTopViewController() else { return }
        let alertController = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            vc.navigationController?.dismiss(animated: true)
        }
        alertController.addAction(action)
        alertController.show(vc, sender: nil)
        vc.present(alertController, animated: true)
    }
}

private extension CGFloat {
    static let logoWidth: CGFloat = 75
    static let logoHeight: CGFloat = 77
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewProtocol, didAuthenticateWithCode code: String) {
        print("Did received code: ", code)
        presenter.fetchAuthToken(code: code)
    }
}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }

        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }

        return base
    }
}

//
//  SplashViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 18.12.2023.
//  
//

import UIKit

protocol SplashViewProtocol: AnyObject {
    
}

final class SplashViewController: UIViewController {
    
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
}

extension SplashViewController: SplashViewProtocol {
    
}

private extension CGFloat {
    static let logoWidth: CGFloat = 75
    static let logoHeight: CGFloat = 77
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.showNext()
    }
}

extension SplashViewController: SplashViewProtocol {
    
}

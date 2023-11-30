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
}

final class MainCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetail(forImageNamed imageName: String) {
        let detailViewController = Assembler.createSingleImegeModule(withImageNamed: imageName)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

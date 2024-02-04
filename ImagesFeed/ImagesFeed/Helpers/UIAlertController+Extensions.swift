//
//  UIAlertController+Extensions.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 04.02.2024.
//  
//

import UIKit

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}

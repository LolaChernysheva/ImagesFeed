//
//  AuthScreenModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.12.2023.
//  
//

import UIKit

struct AuthScreenModel {
    let backgroundColor: UIColor
    let buttonTitle: String
    let buttonColor: UIColor
    let logoImage: UIImage
    let font: UIFont

    static let empty: AuthScreenModel = .init(backgroundColor: .clear, buttonTitle: "", buttonColor: .clear, logoImage: UIImage(), font: UIFont())
}

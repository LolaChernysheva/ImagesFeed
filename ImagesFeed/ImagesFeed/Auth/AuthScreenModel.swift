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

//extension UIFont {
//    convenience init(fontName: String, size: CGFloat, weight: UIFont.Weight) {
//        let descriptor = UIFontDescriptor(name: fontName, size: size).withSymbolicTraits(.traitBold) ?? UIFontDescriptor()
//        self.init(descriptor: descriptor, size: size)
//    }
//}
//

//
//  SingleImageScreenModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 12.12.2023.
//  
//

import Foundation

struct SingleImageScreenModel {
    var imageName: String
    var sharedImageName: String
    
    static let empty = SingleImageScreenModel(imageName: "", sharedImageName: "")
}

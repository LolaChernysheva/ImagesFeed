//
//  ImagesListScreenModel.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 15.11.2023.
//  
//

import UIKit

struct ImagesListScreenModel {
    struct TableData {
        enum Section {
            case simpleSection(cells: [Cell])
            
            var cells: [Cell] {
                switch self {
                case let .simpleSection(cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case imageCell(ImageCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let tableData: TableData
    let backbroundColor: UIColor
    
    static let empty: ImagesListScreenModel = .init(tableData: .init(sections: []), backbroundColor: .clear)
}

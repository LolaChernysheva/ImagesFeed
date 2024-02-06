//
//  Date+Extensions.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 03.02.2024.
//  
//

import Foundation

extension Date {
    
    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()

    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    func makeDisplayString() -> String? {
        let isoString = Self.isoFormatter.string(from: self)
        let isoDate = Self.isoFormatter.date(from: isoString)
        let dateString = Self.displayDateFormatter.string(from: isoDate ?? Date())
        return dateString
    }
}

extension String {
    
    func isoDate() -> Date? {
        let isoDate = Date.isoFormatter.date(from: self)
        let dateString = Date.displayDateFormatter.string(from: isoDate ?? Date())
        return Date.displayDateFormatter.date(from: dateString)
    }
}

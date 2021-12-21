//
//  String+Extension.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/1.
//

import Foundation

extension String {
    func toDate(for formatter: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

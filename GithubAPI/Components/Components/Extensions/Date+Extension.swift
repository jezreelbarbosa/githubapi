//
//  Date+Extension.swift
//  Components
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Foundation

public extension Date {
    func formatted(date: DateFormatter.Style, time: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = date
        formatter.timeStyle = time
        return formatter.string(from: self)
    }
}

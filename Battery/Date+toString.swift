//
//  Date+toString.swift
//  Battery
//
//  Created by yukio on 2022/10/01.
//

import Foundation

extension Date {
    func toString(_ dateFormat: String = "yyyy-MM-dd hh:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = .current
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.locale = NSLocale.system
        return formatter.string(from: self)
    }
}

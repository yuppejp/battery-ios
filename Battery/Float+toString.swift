//
//  Double+toString.swift
//  Battery
//  
//  Created on 2022/09/23
//  


import Foundation

extension Float {
    func toDecimalString(minDigits: Int = 0, maxDigits: Int = 0) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = minDigits
        f.maximumFractionDigits = maxDigits
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    func toIntegerString() -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    func toPercentString(minDigits: Int = 0, maxDigits: Int = 0, percentSymbol: String? = nil) -> String {
        let f = NumberFormatter()
        f.numberStyle = .percent
        f.minimumFractionDigits = minDigits
        f.maximumFractionDigits = maxDigits
        f.percentSymbol = percentSymbol
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

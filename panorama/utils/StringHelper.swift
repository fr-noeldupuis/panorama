//
//  StringHelper.swift
//  panorama
//
//  Created by Noel Dupuis on 28/11/2024.
//
import SwiftUI

extension Double {
    
    func toAmountString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func toAbsoluteAmountString() -> String {
        return abs(self).toAmountString()
    }
}

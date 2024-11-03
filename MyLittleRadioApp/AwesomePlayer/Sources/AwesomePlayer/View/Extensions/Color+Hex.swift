//
//  Color+Hex.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 02/11/2024.
//

import Foundation
import SwiftUI

/// source: https://medium.com/@developer.sreejithnp/how-to-use-hex-code-directly-in-swiftui-using-extensions-374efc2c3c2a
public extension Color {
    public init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0

        Scanner(string: cleanHexCode).scanHexInt64(&rgb)

        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

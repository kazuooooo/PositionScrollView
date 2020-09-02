//
//  Colors.swift
//  PositionScrollViewExample
//
//  Created by 松本和也 on 2020/09/02.
//  Copyright © 2020 松本和也. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

let BLUES = [
    Color(hex: 0x406CEF),
    Color(hex: 0x01359E),
    Color(hex: 0x6F8DC9),
    Color(hex: 0x6D96E9),
    Color(hex: 0x354F85)
]

//
//  Color.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/7/3.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
}

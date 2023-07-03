//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/25.
//

import SwiftUI

@main
struct UberSwiftUIApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}

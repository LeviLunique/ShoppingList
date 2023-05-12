//
//  AddProductsApp.swift
//  AddProducts
//
//  Created by Levi Lunique on 11/05/23.
//

import SwiftUI

@main
struct AddProductsApp: App {
    @StateObject private var productViewModel = ProductViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(productViewModel)
        }
    }
}


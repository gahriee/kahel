//
//  ContentView.swift
//  kahel
//
//  Created by Eli on 5/25/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        RootViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let splashVC = SplashViewController()
        let navController = UINavigationController(rootViewController: splashVC)
        navController.isNavigationBarHidden = true
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No update needed
    }
}

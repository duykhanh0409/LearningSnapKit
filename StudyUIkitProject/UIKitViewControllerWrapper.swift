//
//  UIKitViewControllerWrapper.swift
//  StudyUIkitProject
//
//  Created by Khanh Nguyen on 16/2/26.
//

import SwiftUI
import UIKit

/// Wrapper để hiển thị UIKit ViewController trong SwiftUI
struct UIKitViewControllerWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        // Create Home screen as root
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)

        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance

        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}

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

    func makeUIViewController(context: Context) -> UITabBarController {
        // Create tab bar controller
        let tabBarController = UITabBarController()

        // API Stack Tab - NEW!
        let apiStackVC = APIStackViewController()
        apiStackVC.tabBarItem = UITabBarItem(
            title: "API Demo",
            image: UIImage(systemName: "arrow.down.circle"),
            tag: 0
        )
        let apiStackNav = UINavigationController(rootViewController: apiStackVC)

        // Dynamic Stack Tab
        let stackVC = DynamicStackViewController()
        stackVC.tabBarItem = UITabBarItem(
            title: "Expandable",
            image: UIImage(systemName: "rectangle.stack"),
            tag: 1
        )
        let stackNav = UINavigationController(rootViewController: stackVC)

        // Profile Tab
        let profileVC = SimpleProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            tag: 2
        )
        let profileNav = UINavigationController(rootViewController: profileVC)

        // Set view controllers
        tabBarController.viewControllers = [apiStackNav, stackNav, profileNav]
        tabBarController.selectedIndex = 0  // Start with API Demo tab

        return tabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        // No updates needed
    }
}

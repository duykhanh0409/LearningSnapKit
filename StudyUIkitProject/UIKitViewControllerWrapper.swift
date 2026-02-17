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
        let viewController = SimpleProfileViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}

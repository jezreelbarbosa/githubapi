//
//  AppCoordinator.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit

final class AppCoordinator {
    weak var window: UIWindow?

    init(window: UIWindow? = nil) {
        self.window = window
    }

    func start() {
        let viewController = RepositoriesFactory.make()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }
}

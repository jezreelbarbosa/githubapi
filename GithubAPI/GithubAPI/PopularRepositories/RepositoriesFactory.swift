//
//  RepositoriesFactory.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Networking
import UIKit

enum RepositoriesFactory {
    static func make() -> UIViewController {
        let services = GitHubAPIServices()
        let coordinator = RepositoriesCoordinator()
        let viewModel = RepositoriesViewModel(services: services, coordinator: coordinator)
        let controller = RepositoriesViewController(viewModel: viewModel)
        coordinator.viewController = controller
        return controller
    }
}

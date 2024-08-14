//
//  RepositoriesFactory.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Networking

enum RepositoriesFactory {
    static func make() -> RepositoriesViewController {
        let dispatcher = Dispatcher()
        let service = RepositoriesService(dispatcher: dispatcher)
        let coordinator = RepositoriesCoordinator()
        let viewModel = RepositoriesViewModel(service: service, coordinator: coordinator)
        let controller = RepositoriesViewController(viewModel: viewModel)
        coordinator.viewController = controller
        return controller
    }
}

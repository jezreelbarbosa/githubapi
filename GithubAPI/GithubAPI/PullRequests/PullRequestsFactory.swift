//
//  PullRequestsFactory.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Networking
import UIKit

enum PullRequestsFactory {
    static func make(model: RepositoryDisplayModel) -> UIViewController {
        let services = GitHubAPIServices()
        let coordinator = PullRequestsCoordinator()
        let viewModel = PullRequestsViewModel(services: services, coordinator: coordinator, repository: model)
        let controler = PullRequestsViewController(viewModel: viewModel)
        coordinator.viewController = controler
        return controler
    }
}

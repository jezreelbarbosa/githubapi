//
//  PullRequestsFactory.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Networking
import UIKit

enum PullRequestsFactory {
    static func make(model: RepositoryModel) -> UIViewController {
        let service = PullRequestsService()
        let coordinator = PullRequestsCoordinator()
        let viewModel = PullRequestsViewModel(service: service, coordinator: coordinator, repository: model)
        let controler = PullRequestsViewController(viewModel: viewModel)
        coordinator.viewController = controler
        return controler
    }
}

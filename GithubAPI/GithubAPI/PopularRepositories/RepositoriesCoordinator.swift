//
//  RepositoriesCoordinator.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit

protocol RepositoriesCoordinating {
    func showPullRequestsView(model: RepositoryModel)
}

final class RepositoriesCoordinator: RepositoriesCoordinating {
    // Properties

    weak var viewController: UIViewController?

    // Functions

    func showPullRequestsView(model: RepositoryModel) {
        let navigation = viewController?.navigationController
        let controller = PullRequestsFactory.make(model: model)
        navigation?.pushViewController(controller, animated: true)
    }
}
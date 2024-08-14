//
//  RepositoriesCoordinator.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit

protocol RepositoriesCoordinating {
    func showPullRequestsView()
}

final class RepositoriesCoordinator: RepositoriesCoordinating {
    // Properties

    weak var viewController: UIViewController?

    // Functions

    func showPullRequestsView() {

    }
}

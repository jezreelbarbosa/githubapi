//
//  PullRequestsCoordinator.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit
import SafariServices

protocol PullRequestsCoordinating {
    func showPullRequestDetails(url: URL)
}

final class PullRequestsCoordinator: PullRequestsCoordinating {
    // Properties

    weak var viewController: UIViewController?

    // Functions

    func showPullRequestDetails(url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.modalPresentationStyle = .overFullScreen
        viewController?.present(safari, animated: true)
    }
}

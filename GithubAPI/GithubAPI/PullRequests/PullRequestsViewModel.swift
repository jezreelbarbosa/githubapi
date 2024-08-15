//
//  PullRequestsViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Components

protocol PullRequestsViewModeling {
    var pullrequests: [PullRequestModel] { get }

    var reloadData: Box<Void> { get }
    var reloadCell: Box<Int> { get }
    var pullsCount: Box<(opened: String, closed: String)> { get }

    func loadPullResquests()
    func didSelect(row: Int)
}

final class PullRequestsViewModel: PullRequestsViewModeling {
    // Properties

    var pullrequests: [PullRequestModel] = []

    let reloadData: Box<Void> = Box(())
    let reloadCell: Box<Int> = Box(0)
    var pullsCount: Box<(opened: String, closed: String)> = Box(("", ""))

    let service: PullRequestsServicing
    let coordinator: PullRequestsCoordinating
    let repository: RepositoryModel

    // Lifecycle

    init(service: PullRequestsServicing, coordinator: PullRequestsCoordinating, repository: RepositoryModel) {
        self.service = service
        self.coordinator = coordinator
        self.repository = repository
    }

    // Functions

    func loadPullResquests() {
        service.loadPulls(repo: repository.name, owner: repository.owner.login) { [weak self] result in
            result.successHandler { models in
                self?.handlePullRequests(pulls: models)
            }
            result.failureHandler { error in
                print(error)
            }
        }
    }

    func didSelect(row: Int) {
        // Open web view
    }

    // Private functions

    private func handlePullRequests(pulls: [PullRequestModel]) {
        let opened = pulls.filter({ $0.state == .open })
        pullrequests.append(contentsOf: opened)
        reloadData.fire()
        getOwnersNames(for: opened)

        let openedCount = opened.count
        let closedCount = pulls.count - openedCount
        pullsCount.value = ("\(openedCount)", "\(closedCount)")
    }

    private func getOwnersNames(for pulls: [PullRequestModel]) {
        pulls.enumerated().forEach { index, pull in
            service.loadName(with: pull.user.login) { [weak self] result in
                result.successHandler { user in
                    self?.pullrequests[index].user.name = user.name
                    self?.reloadCell.value = index
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
    }
}

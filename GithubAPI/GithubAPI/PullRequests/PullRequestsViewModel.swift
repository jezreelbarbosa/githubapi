//
//  PullRequestsViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Components

protocol PullRequestsViewModeling {
    var navigationTitleBox: Box<String> { get }
    var pullrequestsBox: Box<[PullRequestModel]> { get }
    var isLoadingBox: Box<Bool> { get }
    var reloadCellBox: Box<Int> { get }
    var alertBox: Box<AlertModel> { get }

    func loadPullResquests()
    func didSelectSegment(index: Int)
    func didSelect(row: Int)
    func reloadPage()
}

final class PullRequestsViewModel: PullRequestsViewModeling {
    // Properties

    var allPullrequests: [PullRequestModel] = []

    let navigationTitleBox: Box<String>

    let pullrequestsBox: Box<[PullRequestModel]> = Box([])
    let isLoadingBox: Box<Bool> = Box(false)
    let reloadCellBox: Box<Int> = Box(0)
    let alertBox: Box<AlertModel> = Box(.errorAlert)

    let service: PullRequestsServicing
    let coordinator: PullRequestsCoordinating
    let repository: RepositoryModel

    // Lifecycle

    init(service: PullRequestsServicing, coordinator: PullRequestsCoordinating, repository: RepositoryModel) {
        self.service = service
        self.coordinator = coordinator
        self.repository = repository
        self.navigationTitleBox = Box(repository.name)
    }

    // Functions

    func loadPullResquests() {
        isLoadingBox.value = true
        service.loadPulls(repo: repository.name, owner: repository.owner.login) { [weak self] result in
            result.successHandler { models in
                self?.getOwnersNames(for: models)
            }
            result.failureHandler { error in
                self?.alertBox.value = .errorAlert
                print(error)
            }
        }
    }

    func didSelect(row: Int) {
        let url = pullrequestsBox.value[row].htmlUrl
        coordinator.showPullRequestDetails(url: url)
    }

    func reloadPage() {
        allPullrequests = []
        pullrequestsBox.value = []
        loadPullResquests()
    }

    func didSelectSegment(index: Int) {
        switch index {
        case 0: // Open
            pullrequestsBox.value = allPullrequests.filter({ $0.state == .open })
        case 1: // Closed
            pullrequestsBox.value = allPullrequests.filter({ $0.state == .closed })
        default: // All
            pullrequestsBox.value = allPullrequests
        }
    }

    // Private functions

    private func getOwnersNames(for pulls: [PullRequestModel]) {
        let group = DispatchGroup()
        var pulls = pulls
        pulls.enumerated().forEach { index, pull in
            group.enter()
            service.loadName(with: pull.user.login) { result in
                group.leave()
                result.successHandler { user in
                    pulls[index].user.name = user.name
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
        group.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            guard let self = self else { return }
            self.allPullrequests = pulls
            self.pullrequestsBox.value = pulls.filter({ $0.state == .open })
            self.isLoadingBox.value = false
        }
    }
}

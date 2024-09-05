//
//  PullRequestsViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Components
import Networking

protocol PullRequestsViewModeling {
    var navigationTitleBox: Box<String> { get }
    var pullrequestsBox: Box<[PullRequestDisplayModel]> { get }
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

    var allPullrequests: [PullRequestDisplayModel] = []

    let navigationTitleBox: Box<String>

    let pullrequestsBox: Box<[PullRequestDisplayModel]> = Box([])
    let isLoadingBox: Box<Bool> = Box(false)
    let reloadCellBox: Box<Int> = Box(0)
    let alertBox: Box<AlertModel> = Box(.errorAlert)

    typealias Services = HasPullRequestsService & HasUserInfoService
    let services: Services
    let coordinator: PullRequestsCoordinating
    let repository: RepositoryDisplayModel

    // Lifecycle

    init(services: Services, coordinator: PullRequestsCoordinating, repository: RepositoryDisplayModel) {
        self.services = services
        self.coordinator = coordinator
        self.repository = repository
        self.navigationTitleBox = Box(repository.name)
    }

    // Functions

    func loadPullResquests() {
        isLoadingBox.value = true
        services.pullRequestsServices.loadPulls(owner: repository.username, repo: repository.name) { [weak self] result in
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
        var pullsDisplay = pulls.map(\.displayModel)
        pullsDisplay.enumerated().forEach { index, pull in
            group.enter()
            services.userInfoServices.loadUser(with: pull.username) { result in
                group.leave()
                result.successHandler { user in
                    pullsDisplay[index].fullname = user.name
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
        group.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            guard let self = self else { return }
            self.allPullrequests = pullsDisplay
            self.pullrequestsBox.value = pullsDisplay.filter({ $0.state == .open })
            self.isLoadingBox.value = false
        }
    }
}

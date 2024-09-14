//
//  RepositoriesViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import Components
import Networking

protocol RepositoriesViewModeling {
    var repositories: [RepositoryDisplayModel] { get }

    var isLoadingBox: Box<Bool> { get }
    var isTableLoadingBox: Box<Bool> { get }
    var reloadDataBox: Box<Void> { get }
    var reloadCellBox: Box<Int> { get }
    var alertBox: Box<AlertModel> { get }

    func loadNextPage()
    func didSelect(row: Int)
    func reloadPage()
}

final class RepositoriesViewModel: RepositoriesViewModeling {
    // Properties

    var repositories: [RepositoryDisplayModel] = []

    let isLoadingBox: Box<Bool> = Box(false)
    let isTableLoadingBox: Box<Bool> = Box(false)
    let reloadDataBox: Box<Void> = Box(())
    let reloadCellBox: Box<Int> = Box(0)
    let alertBox: Box<AlertModel> = Box(.errorAlert)
    let pageBox: Box<Int> = Box(1)

    typealias Services = HasRepositoriesService & HasUserInfoService
    let services: Services
    let coordinator: RepositoriesCoordinating

    // Lifecycle

    init(services: Services, coordinator: RepositoriesCoordinating) {
        self.services = services
        self.coordinator = coordinator
    }

    // Functions

    func loadNextPage() {
        if pageBox.value == 1 {
            isLoadingBox.value = true
        } else {
            isTableLoadingBox.value = true
        }
        services.repositoriesService.loadPage(pageBox.value) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingBox.value = false
            self.isTableLoadingBox.value = false
            result.successHandler { model in
                let repos = model.items.map(\.displayModel)
                let count = self.repositories.count
                self.pageBox.value += 1
                self.repositories.append(contentsOf: repos)
                self.reloadDataBox.fire()
                self.getOwnersNames(for: repos, count: count)
            }
            result.failureHandler { error in
                self.alertBox.value = .errorAlert
                print(error)
            }
        }
    }

    func didSelect(row: Int) {
        let repo = repositories[row]
        coordinator.showPullRequestsView(model: repo)
    }

    func reloadPage() {
        pageBox.value = 1
        repositories = []
        reloadDataBox.fire()
        loadNextPage()
    }

    // Private functions

    private func getOwnersNames(for repos: [RepositoryDisplayModel], count: Int) {
        repos.enumerated().forEach { rIndex, repo in
            let index = rIndex + count
            services.userInfoServices.loadUser(with: repo.username) { [weak self] result in
                result.successHandler { user in
                    self?.repositories[index].fullName = user.name
                    self?.reloadCellBox.value = index
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
    }
}

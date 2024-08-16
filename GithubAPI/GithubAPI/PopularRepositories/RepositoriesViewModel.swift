//
//  RepositoriesViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import Components

protocol RepositoriesViewModeling {
    var repositories: [RepositoryModel] { get }

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

    var repositories: [RepositoryModel] = []

    let isLoadingBox: Box<Bool> = Box(false)
    let isTableLoadingBox: Box<Bool> = Box(false)
    let reloadDataBox: Box<Void> = Box(())
    let reloadCellBox: Box<Int> = Box(0)
    let alertBox: Box<AlertModel> = Box(.errorAlert)
    let pageBox: Box<Int> = Box(1)

    let service: RepositoriesServicing
    let coordinator: RepositoriesCoordinating

    // Lifecycle

    init(service: RepositoriesServicing, coordinator: RepositoriesCoordinating) {
        self.service = service
        self.coordinator = coordinator
    }

    // Functions

    func loadNextPage() {
        if pageBox.value == 1 {
            isLoadingBox.value = true
        } else {
            isTableLoadingBox.value = true
        }
        service.loadPage(pageBox.value) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingBox.value = false
            self.isTableLoadingBox.value = false
            result.successHandler { model in
                let repos = model.items
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

    private func getOwnersNames(for repos: [RepositoryModel], count: Int) {
        repos.enumerated().forEach { rIndex, repo in
            let index = rIndex + count
            service.loadName(with: repo.owner.login) { [weak self] result in
                result.successHandler { user in
                    self?.repositories[index].owner.name = user.name
                    self?.reloadCellBox.value = index
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
    }
}

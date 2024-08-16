//
//  RepositoriesViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import Components

protocol RepositoriesViewModeling {
    var repositories: [RepositoryModel] { get }

    var isLoading: Box<Bool> { get }
    var isTableLoading: Box<Bool> { get }
    var reloadData: Box<Void> { get }
    var reloadCell: Box<Int> { get }
    var alertBox: Box<AlertModel> { get }

    func loadNextPage()
    func didSelect(row: Int)
    func reloadPage()
}

final class RepositoriesViewModel: RepositoriesViewModeling {
    // Properties

    var repositories: [RepositoryModel] = []

    let isLoading: Box<Bool> = Box(false)
    let isTableLoading: Box<Bool> = Box(false)
    let reloadData: Box<Void> = Box(())
    let reloadCell: Box<Int> = Box(0)
    let alertBox: Box<AlertModel> = Box(.errorAlert)

    var page: Int = 1

    let service: RepositoriesServicing
    let coordinator: RepositoriesCoordinating

    // Lifecycle

    init(service: RepositoriesServicing, coordinator: RepositoriesCoordinating) {
        self.service = service
        self.coordinator = coordinator
    }

    // Functions

    func loadNextPage() {
        if page == 1 {
            isLoading.value = true
        } else {
            isTableLoading.value = true
        }
        service.loadPage(page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            self.isTableLoading.value = false
            result.successHandler { model in
                let repos = model.items
                let count = self.repositories.count
                self.page += 1
                self.repositories.append(contentsOf: repos)
                self.reloadData.fire()
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
        page = 1
        repositories = []
        reloadData.fire()
        loadNextPage()
    }

    // Private functions

    private func getOwnersNames(for repos: [RepositoryModel], count: Int) {
        repos.enumerated().forEach { rIndex, repo in
            let index = rIndex + count
            service.loadName(with: repo.owner.login) { [weak self] result in
                result.successHandler { user in
                    self?.repositories[index].owner.name = user.name
                    self?.reloadCell.value = index
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
    }
}

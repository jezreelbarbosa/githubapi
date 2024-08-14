//
//  RepositoriesViewModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import Components

protocol RepositoriesViewModeling {
    var repositories: [RepositoryModel] { get }

    var reloadData: Box<Void> { get }
    var reloadCell: Box<Int> { get }

    func loadNextPage()
    func didSelect(item: RepositoryModel)
}

final class RepositoriesViewModel: RepositoriesViewModeling {
    // Properties

    private(set) var repositories: [RepositoryModel] = []

    let reloadData: Box<Void> = Box(())
    let reloadCell: Box<Int> = Box(0)

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
        service.loadPage(page) { [weak self] result in
            guard let self = self else { return }
            result.successHandler { repos in
                let count = self.repositories.count
                self.page += 1
                self.repositories.append(contentsOf: repos)
                self.reloadData.fire()
                self.getOwnersNames(for: repos, count: count)
            }
            result.failureHandler { error in
                print(error)
            }
        }
    }

    func didSelect(item: RepositoryModel) {
        coordinator.showPullRequestsView()
    }

    // Private functions

    private func getOwnersNames(for repos: [RepositoryModel], count: Int) {
        repos.enumerated().forEach { rIndex, repo in
            let index = rIndex + count
            service.loadName(with: repo.owner.login) { [weak self] result in
                result.successHandler { name in
                    self?.repositories[index].owner.name = name
                    self?.reloadCell.value = index
                }
                result.failureHandler { error in
                    print(error)
                }
            }
        }
    }
}

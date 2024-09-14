//
//  RepoMocks.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
@testable import GithubAPI

final class RepositoriesCoordinatorMock: RepositoriesCoordinating {
    var showPullRequestsViewImpl: (RepositoryDisplayModel) -> Void = { _ in XCTFail() }
    func showPullRequestsView(model: RepositoryDisplayModel) {
        showPullRequestsViewImpl(model)
    }
}

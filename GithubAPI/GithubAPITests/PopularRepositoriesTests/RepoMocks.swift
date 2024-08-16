//
//  RepoMocks.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
@testable import GithubAPI

final class RepositoriesServiceMock: RepositoriesServicing {
    var loadPageImpl: (Int, @escaping RepositoriesCompletion) -> Void = { _, _ in XCTFail() }
    func loadPage(_ page: Int, completion: @escaping RepositoriesCompletion) {
        loadPageImpl(page, completion)
    }

    var loadNameImpl: (String, @escaping NameCompletion) -> Void = { _, _ in XCTFail() }
    func loadName(with login: String, completion: @escaping NameCompletion) {
        loadNameImpl(login, completion)
    }
}

final class RepositoriesCoordinatorMock: RepositoriesCoordinating {
    var showPullRequestsViewImpl: (RepositoryModel) -> Void = { _ in XCTFail() }
    func showPullRequestsView(model: RepositoryModel) {
        showPullRequestsViewImpl(model)
    }
}

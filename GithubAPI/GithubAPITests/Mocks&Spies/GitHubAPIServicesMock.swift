//
//  GitHubAPIServicesMock.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 05/09/24.
//

import XCTest
import Networking
@testable import GithubAPI

struct GitHubAPIServicesMock: AllGitHubAPIServices {
    let repositoriesService: RepositoriesServicing
    let pullRequestsServices: PullRequestsServicing
    let userInfoServices: UserInfoServicing
}

final class RepositoriesServiceMock: RepositoriesServicing {
    var loadPageImpl: (Int, @escaping RepositoriesCompletion) -> Void = { _, _ in XCTFail() }
    func loadPage(_ page: Int, completion: @escaping RepositoriesCompletion) {
        loadPageImpl(page, completion)
    }
}

final class PullRequestsServiceMock: PullRequestsServicing {
    var loadPullsImpl: (String, String, @escaping PullRequestsCompletion) -> Void = { _, _, _ in XCTFail() }
    func loadPulls(owner: String, repo: String, completion: @escaping PullRequestsCompletion) {
        loadPullsImpl(owner, repo, completion)
    }
}

final class UserInfoServiceMock: UserInfoServicing {
    var loadUserImpl: (String, @escaping UserInfoCompletion) -> Void = { _, _ in XCTFail() }
    func loadUser(with login: String, completion: @escaping UserInfoCompletion) {
        loadUserImpl(login, completion)
    }
}

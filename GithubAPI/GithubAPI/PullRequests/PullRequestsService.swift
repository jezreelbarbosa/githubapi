//
//  PullRequestsService.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Networking

typealias PullRequestsCompletion = (Result<[PullRequestModel], TargetError>) -> Void
typealias PullUserNameCompletion = (Result<UserModel, TargetError>) -> Void

protocol PullRequestsServicing {
    func loadPulls(repo: String, owner: String, completion: @escaping PullRequestsCompletion)
    func loadName(with login: String, completion: @escaping PullUserNameCompletion)
}

extension PullRequestsService {
    func pullRequests(repo: String, owner: String) -> GitHubApiTarget {
        GitHubApiTarget(
            path: "/repos/\(owner)/\(repo)/pulls",
            parameters: ["state": "all"]
        )
    }

    func user(login: String) -> GitHubApiTarget {
        GitHubApiTarget(path: "/users/\(login)")
    }
}

final class PullRequestsService: ServiceAPI, PullRequestsServicing {
    // Lifecycle

    override init(dispacher: Dispatching = Dispatcher(), jsonDecoder: JSONDecoder = JSONDecoder()) {
        super.init(dispacher: dispacher, jsonDecoder: jsonDecoder)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
    }

    // Functions

    func loadPulls(repo: String, owner: String, completion: @escaping PullRequestsCompletion) {
        let endpoint = pullRequests(repo: repo, owner: owner)
        makeRequest(endpoint: endpoint, completion: completion)
    }

    func loadName(with login: String, completion: @escaping PullUserNameCompletion) {
        let endpoint = user(login: login)
        makeRequest(endpoint: endpoint, completion: completion)
    }
}

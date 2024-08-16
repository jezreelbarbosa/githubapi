//
//  RepositoriesService.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Networking

typealias RepositoriesCompletion = (Result<RepositoriesModel, TargetError>) -> Void
typealias NameCompletion = (Result<UserModel, TargetError>) -> Void

protocol RepositoriesServicing {
    func loadPage(_ page: Int, completion: @escaping RepositoriesCompletion)
    func loadName(with login: String, completion: @escaping NameCompletion)
}

extension RepositoriesService {
    func swiftPopular(page: Int) -> GitHubApiTarget {
        GitHubApiTarget(
            path: "/search/repositories",
            parameters: [
                "q": "language:Swift",
                "sort": "stars",
                "page": "\(page)"
            ]
        )
    }

    func user(login: String) -> GitHubApiTarget {
        GitHubApiTarget(path: "/users/\(login)")
    }
}

final class RepositoriesService: ServiceAPI, RepositoriesServicing {
    // Lifecycle

    override init(dispacher: Dispatching = Dispatcher(), jsonDecoder: JSONDecoder = JSONDecoder()) {
        super.init(dispacher: dispacher, jsonDecoder: jsonDecoder)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // functions

    func loadPage(_ page: Int, completion: @escaping RepositoriesCompletion) {
        let endpoint = swiftPopular(page: page)
        makeRequest(endpoint: endpoint, completion: completion)
    }

    func loadName(with login: String, completion: @escaping NameCompletion) {
        let endpoint = user(login: login)
        makeRequest(endpoint: endpoint, completion: completion)
    }
}

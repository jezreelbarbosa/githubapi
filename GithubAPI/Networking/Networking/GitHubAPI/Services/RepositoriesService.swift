//
//  RepositoriesService.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

public typealias RepositoriesCompletion = (Result<RepositoriesModel, TargetError>) -> Void

public protocol HasRepositoriesService {
    var repositoriesService: RepositoriesServicing { get }
}

public protocol RepositoriesServicing {
    func loadPage(_ page: Int, completion: @escaping RepositoriesCompletion)
}

final class RepositoriesService: ServiceAPI, RepositoriesServicing {
    func loadPage(_ page: Int, completion: @escaping RepositoriesCompletion) {
        let endpoint = GitHubApiTarget(
            path: "/search/repositories",
            parameters: [
                "q": "language:Swift",
                "sort": "stars",
                "page": "\(page)"
            ]
        )
        makeRequest(endpoint: endpoint, completion: completion)
    }
}

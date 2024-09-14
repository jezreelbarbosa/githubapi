//
//  PullRequestsService.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

public typealias PullRequestsCompletion = (Result<[PullRequestModel], TargetError>) -> Void

public protocol HasPullRequestsService {
    var pullRequestsServices: PullRequestsServicing { get }
}

public protocol PullRequestsServicing {
    func loadPulls(owner: String, repo: String, completion: @escaping PullRequestsCompletion)
}

public final class PullRequestsService: ServiceAPI, PullRequestsServicing {
    public func loadPulls(owner: String, repo: String, completion: @escaping PullRequestsCompletion) {
        let endpoint =  GitHubApiTarget(
            path: "/repos/\(owner)/\(repo)/pulls",
            parameters: ["state": "all"]
        )
        makeRequest(endpoint: endpoint, completion: completion)
    }
}

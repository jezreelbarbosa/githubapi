//
//  GitHubAPIServices.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

typealias AllGitHubAPIServices = HasUserInfoService & HasPullRequestsService & HasRepositoriesService

public final class GitHubAPIServices: ServiceAPI, AllGitHubAPIServices {
    // Services

    public lazy var userInfoServices: UserInfoServicing =
        UserInfoService(dispacher: dispacher, jsonDecoder: jsonDecoder)

    public lazy var pullRequestsServices: PullRequestsServicing =
        PullRequestsService(dispacher: dispacher, jsonDecoder: jsonDecoder)

    public lazy var repositoriesService: RepositoriesServicing =
        RepositoriesService(dispacher: dispacher, jsonDecoder: jsonDecoder)

    // Lifecycle

    public override init(dispacher: Dispatching = Dispatcher(), jsonDecoder: JSONDecoder = JSONDecoder()) {
        super.init(dispacher: dispacher, jsonDecoder: jsonDecoder)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
    }
}

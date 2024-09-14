//
//  PullRequestDisplayModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Networking

struct PullRequestDisplayModel: Equatable {
    let title: String
    let body: String?
    let createdAt: Date
    let state: PullRequestStateModel
    let htmlUrl: URL
    let username: String
    let avatarUrl: URL?
    var fullname: String?

    var date: String {
        createdAt.formatted(date: .medium, time: .none)
    }

    var accessibilityLabel: String {
        let accDescription = "\(title). "
        let accDate = "Created at \(createdAt.formatted(date: .long, time: .none)). "
        let accUser = "From \(fullname ?? username)"
        return accDescription + accDate + accUser
    }
}

extension PullRequestModel {
    var displayModel: PullRequestDisplayModel {
        PullRequestDisplayModel(
            title: title,
            body: body,
            createdAt: createdAt,
            state: state,
            htmlUrl: htmlUrl,
            username: user.login,
            avatarUrl: user.avatarUrl,
            fullname: nil
        )
    }
}

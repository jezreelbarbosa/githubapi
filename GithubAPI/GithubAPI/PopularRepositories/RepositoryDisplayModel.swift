//
//  RepositoryDisplayModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 05/09/24.
//

import Networking

struct RepositoryDisplayModel: Equatable {
    let name: String
    let forks: String
    let stars: String
    let username: String
    var fullName: String?
    let description: String?
    let avatarUrl: URL?

    var accessibilityLabel: String {
        let accDescription = "\(name). \(description ?? ""). "
        let accCount = "\(forks) Forks. \(stars) Stars. "
        let accUser = "From \(fullName ?? username)"
        return accDescription + accCount + accUser
    }
}

extension RepositoryModel {
    var displayModel: RepositoryDisplayModel {
        RepositoryDisplayModel(
            name: name,
            forks: "\(forksCount)",
            stars: "\(stargazersCount)",
            username: owner.login,
            description: description,
            avatarUrl: owner.avatarUrl
        )
    }
}

//
//  RepositoriesModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

struct RepositoriesModel: Decodable {
    let items: [RepositoryModel]
}

struct RepositoryModel: Decodable {
    let name: String
    let description: String?
    let forksCount: Int
    let stargazersCount: Int
    var owner: OwnerModel
}

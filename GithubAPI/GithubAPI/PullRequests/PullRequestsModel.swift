//
//  PullRequestsModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Foundation

struct PullRequestModel: Equatable, Decodable {
    let title: String
    let body: String?
    let state: PullRequestStateModel
    let createdAt: Date
    let htmlUrl: URL
    var user: OwnerModel
}

enum PullRequestStateModel: String, Equatable, Decodable {
    case `open`
    case closed
}

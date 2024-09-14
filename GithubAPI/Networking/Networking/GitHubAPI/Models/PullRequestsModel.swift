//
//  PullRequestsModel.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

public struct PullRequestModel: Equatable, Decodable {
    public let title: String
    public let body: String?
    public let state: PullRequestStateModel
    public let createdAt: Date
    public let htmlUrl: URL
    public let user: OwnerModel
}

public enum PullRequestStateModel: String, Equatable, Decodable {
    case `open`
    case closed
}

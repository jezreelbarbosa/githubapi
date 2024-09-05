//
//  RepositoryModel.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

public struct RepositoryModel: Equatable, Decodable {
    public let name: String
    public let description: String?
    public let forksCount: Int
    public let stargazersCount: Int
    public let owner: OwnerModel
}

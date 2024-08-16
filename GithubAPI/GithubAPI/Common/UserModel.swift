//
//  UserModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 15/08/24.
//

import Foundation

struct OwnerModel: Decodable {
    let avatarUrl: URL?
    let login: String
    var name: String?
}

struct UserModel: Decodable {
    let name: String?
}

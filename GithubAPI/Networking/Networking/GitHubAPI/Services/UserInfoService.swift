//
//  UserInfoService.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

public typealias UserInfoCompletion = (Result<UserModel, TargetError>) -> Void

public protocol HasUserInfoService {
    var userInfoServices: UserInfoServicing { get }
}

public protocol UserInfoServicing {
    func loadUser(with login: String, completion: @escaping UserInfoCompletion)
}

public final class UserInfoService: ServiceAPI, UserInfoServicing {
    public func loadUser(with login: String, completion: @escaping UserInfoCompletion) {
        let endpoint = GitHubApiTarget(
            path: "/users/\(login)"
        )
        makeRequest(endpoint: endpoint, completion: completion)
    }
}

//
//  GitHubApiTarget.swift
//  Networking
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

fileprivate let token = ""

public struct GitHubApiTarget: Equatable, TargetType {
    public var baseURL: String = "https://api.github.com"
    public var body: Data? = nil
    public var headers: [String : String]? = [
        "accept": "application/vnd.github+json",
        "Authorization": "Bearer \(token)"
    ]
    public var cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData
    public var method: String = "GET"

    public var path: String
    public var parameters: [String : String]?

    public init(
        path: String,
        parameters: [String : String]? = nil
    ) {
        self.path = path
        self.parameters = parameters
    }
}

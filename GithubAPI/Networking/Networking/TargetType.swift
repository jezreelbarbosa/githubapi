//
//  TargetType.swift
//  Networking
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

public protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var method: String { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

//
//  OwnerModel.swift
//  Networking
//
//  Created by Jezreel Barbosa on 04/09/24.
//

import Foundation

public struct OwnerModel: Equatable, Decodable {
    public let avatarUrl: URL?
    public let login: String
}

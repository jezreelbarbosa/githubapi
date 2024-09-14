//
//  AlertModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 15/08/24.
//

import Foundation

public struct AlertModel: Equatable {
    public let title: String
    public let message: String
    public let button: String
}

public extension AlertModel {
    static var errorAlert: AlertModel {
        AlertModel(
            title: "Something went wrong",
            message: "Please try again, read the README file or contact us for help",
            button: "Try again"
        )
    }
}

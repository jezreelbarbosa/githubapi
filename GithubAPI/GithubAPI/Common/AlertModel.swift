//
//  AlertModel.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 15/08/24.
//

import Foundation

struct AlertModel: Equatable {
    let title: String
    let message: String
    let button: String
}

extension AlertModel {
    static var errorAlert: AlertModel {
        AlertModel(
            title: "Something went wrong",
            message: "Please try again, read the README file or contact us for help",
            button: "Try again"
        )
    }
}

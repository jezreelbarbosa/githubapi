//
//  RepositoriesView.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import UIKit
import Components
import Stevia

final class RepositoriesView: UIView {
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
        initLayout()
        initStyle()
    }

    required init?(coder: NSCoder) { nil }

    private func initSubview() {
        sv(
            tableView
        )
    }

    private func initLayout() {
        tableView.fillContainer()
    }

    private func initStyle() {
        style { s in
            s.backgroundColor = .white
        }
    }
}

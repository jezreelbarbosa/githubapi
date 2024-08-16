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
    // Views

    let tableView = UITableView()
    let activity = UIActivityIndicatorView()

    let footerView = UIView()
    let tableActivity = UIActivityIndicatorView()

    // Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
        initLayout()
        initStyle()
    }

    required init?(coder: NSCoder) { nil }

    private func initSubview() {
        sv(
            tableView,
            activity
        )
        tableView.tableFooterView = footerView.sv(
            tableActivity
        )
    }

    private func initLayout() {
        tableView.fillContainer()
        activity.centerInContainer()
        tableActivity.centerInContainer().fillVertically(m: 8)
        tableView.layoutTableHeaderFooterView()
    }

    private func initStyle() {
        style { s in
            s.backgroundColor = .secondarySystemBackground
        }
        tableView.style { s in
            s.backgroundColor = .clear
        }
        activity.style { s in
            s.style = .large
            s.hidesWhenStopped = true
        }
        tableActivity.style { s in
            s.style = .medium
            s.hidesWhenStopped = true
        }
    }
}

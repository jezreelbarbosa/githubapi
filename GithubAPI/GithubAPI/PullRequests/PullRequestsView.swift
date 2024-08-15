//
//  PullRequestsView.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit
import Components
import Stevia

final class PullRequestsView: UIView {
    // Views

    let tableView = UITableView()
    let activity = UIActivityIndicatorView()

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
    }

    private func initLayout() {
        tableView.fillContainer()
        activity.centerInContainer()
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
    }

    // Functions

    func setContentPulls(opened: String, closed: String) {
        print("\(opened) opened / \(closed) closed")
    }
}

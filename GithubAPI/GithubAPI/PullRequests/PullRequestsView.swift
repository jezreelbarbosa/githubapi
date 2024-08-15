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

    let tableView = UITableView()

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

    // Functions

    func setContentPulls(opened: String, closed: String) {
        print("\(opened) opened / \(closed) closed")
    }
}

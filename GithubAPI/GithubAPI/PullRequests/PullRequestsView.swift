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
    let segmentedControl = UISegmentedControl()

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
            segmentedControl,
            tableView,
            activity
        )
    }

    private func initLayout() {
        segmentedControl.fillHorizontally(m: 16).Top == safeAreaLayoutGuide.Top + 8
        tableView.fillHorizontally().bottom(0).Top == segmentedControl.Bottom + 16
        activity.centerInContainer()
    }

    private func initStyle() {
        style { s in
            s.backgroundColor = .secondarySystemBackground
        }
        segmentedControl.style { s in
            s.insertSegment(withTitle: "Open", at: 0, animated: false)
            s.insertSegment(withTitle: "Closed", at: 1, animated: false)
            s.insertSegment(withTitle: "All", at: 2, animated: false)
            s.selectedSegmentIndex = 0
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

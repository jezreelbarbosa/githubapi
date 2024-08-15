//
//  PullRequestsViewController.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit
import Components

final class PullRequestsViewController: UICodeViewController<PullRequestsViewModeling, PullRequestsView> {
    // Lifecycle

    override func viewDidLoad() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self

        viewModel.navigationTitle.bindAndFire { [weak self] title in
            self?.navigationItem.title = title
        }
        viewModel.isLoading.bind { [weak self] isLoading in
            self?.rootView.activity.animate(isLoading)
        }
        viewModel.reloadData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.rootView.tableView.reloadData()
            }
        }
        viewModel.reloadCell.bind { [weak self] row in
            DispatchQueue.main.async {
                self?.rootView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
        }

        viewModel.pullsCount.bind { [weak self] opened, closed in
            self?.rootView.setContentPulls(opened: opened, closed: closed)
        }

        viewModel.loadPullResquests()
    }
}

extension PullRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pullrequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PullRequestCell.self)
        cell.setContent(model: viewModel.pullrequests[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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

        viewModel.navigationTitleBox.bindAndFire { [weak self] title in
            self?.navigationItem.title = title
        }
        viewModel.isLoadingBox.bind { [weak self] isLoading in
            self?.rootView.activity.animate(isLoading)
        }
        viewModel.pullrequestsBox.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.rootView.tableView.reloadData()
            }
        }
        viewModel.alertBox.bind { [weak self] model in
            let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
            let action = UIAlertAction(title: model.button, style: .default) { [weak alert] _ in
                self?.viewModel.reloadPage()
                alert?.dismiss(animated: true)
            }
            alert.addAction(action)
            DispatchQueue.main.async {
                self?.present(alert, animated: true)
            }
        }
        rootView.segmentedControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)

        viewModel.loadPullResquests()
    }

    // Functions

    @objc func didSelectSegment() {
        viewModel.didSelectSegment(index: rootView.segmentedControl.selectedSegmentIndex)
    }
}

extension PullRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pullrequestsBox.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PullRequestCell.self)
        cell.setContent(model: viewModel.pullrequestsBox.value[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

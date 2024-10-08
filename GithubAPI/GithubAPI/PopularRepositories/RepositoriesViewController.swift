//
//  RepositoriesViewController.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import UIKit
import Components

final class RepositoriesViewController: UICodeViewController<RepositoriesViewModeling, RepositoriesView> {
    // Lifecycle

    override func viewDidLoad() {
        navigationItem.title = "Swift Popular"

        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self

        viewModel.isLoadingBox.bind { [weak self] isLoading in
            self?.rootView.activity.animate(isLoading)
        }
        viewModel.isTableLoadingBox.bind { [weak self] isLoading in
            self?.rootView.tableActivity.animate(isLoading)
        }
        viewModel.reloadDataBox.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.rootView.tableView.reloadData()
            }
        }
        viewModel.reloadCellBox.bind { [weak self] row in
            DispatchQueue.main.async {
                let index = [IndexPath(row: row, section: 0)]
                self?.rootView.tableView.reloadRows(at: index, with: .none)
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

        viewModel.loadNextPage()
    }
}

extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RepositoryCell.self)
        cell.setContent(model: viewModel.repositories[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.repositories.count {
            viewModel.loadNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

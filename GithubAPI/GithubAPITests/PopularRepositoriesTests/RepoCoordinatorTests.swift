//
//  RepoCoordinatorTests.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
@testable import GithubAPI

extension RepositoriesCoordinatorTests {
    typealias Sut = RepositoriesCoordinator

    final class Fields {
        var events: [String] = []

        let viewController = UIViewControllerSpy()
        let navigation = UINavigationControllerSpy()

        let model = RepositoryDisplayModel(name: "", forks: "", stars: "", username: "",
                                           description: "", avatarUrl: nil)
    }

    func makeSut() -> (Sut, Fields) {
        let fields = Fields()
        let sut = Sut()
        sut.viewController = fields.viewController
        return (sut, fields)
    }
}

final class RepositoriesCoordinatorTests: XCTestCase {
    func testShowPullRequestsView_whenWithViewInsideNavigation_shouldPushPullRequestsViewController() {
        let (sut, fields) = makeSut()

        fields.viewController.navigationControllerImpl = { [weak fields] in
            fields?.events.append("view.getNavigation")
            return fields?.navigation
        }
        fields.navigation.pushViewControllerImpl = { [weak fields] view, animated in
            fields?.events.append("navigation:\(animated)")
            XCTAssert(view is PullRequestsViewController)
        }

        sut.showPullRequestsView(model: fields.model)

        XCTAssertEqual(fields.events, ["view.getNavigation", "navigation:true"])
    }
}

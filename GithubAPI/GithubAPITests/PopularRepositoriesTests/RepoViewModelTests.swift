//
//  RepoViewModelTests.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 15/08/24.
//

import XCTest
import Components
@testable import Networking
@testable import GithubAPI

extension RepoViewModelTests {
    typealias Sut = RepositoriesViewModel

    final class Fields {
        var events: [String] = []

        let repositoriesService = RepositoriesServiceMock()
        let pullRequestsServices = PullRequestsServiceMock()
        let userInfoServices = UserInfoServiceMock()

        lazy var services = GitHubAPIServicesMock(
            repositoriesService: repositoriesService,
            pullRequestsServices: pullRequestsServices,
            userInfoServices: userInfoServices
        )
        let coordinator = RepositoriesCoordinatorMock()
    }

    func makeRepositories(count: Int) -> [RepositoryModel] {
        var repos: [RepositoryModel] = []
        for _ in 0..<count {
            let repo = RepositoryModel(
                name: UUID().uuidString,
                description: UUID().uuidString,
                forksCount: Int.random(in: 0...999),
                stargazersCount: Int.random(in: 0...999),
                owner: OwnerModel(
                    avatarUrl: URL(string: UUID().uuidString),
                    login: UUID().uuidString
                )
            )
            repos.append(repo)
        }
        return repos
    }

    func makeSut() -> (Sut, Fields) {
        let fields = Fields()
        let sut = Sut(services: fields.services, coordinator: fields.coordinator)
        sut.isLoadingBox.bind { [weak fields] isLoading in
            fields?.events.append("loading:\(isLoading)")
        }
        sut.reloadDataBox.bind { [weak fields] _ in
            fields?.events.append("reloadData")
        }
        sut.isTableLoadingBox.bind { [weak fields] isTableLoading in
            fields?.events.append("tableLoading:\(isTableLoading)")
        }
        sut.reloadCellBox.bind { [weak fields] row in
            fields?.events.append("cell:\(row)")
        }
        sut.alertBox.bind { [weak fields] alert in
            fields?.events.append("alert:\(alert)")
        }
        sut.pageBox.bind { [weak fields] page in
            fields?.events.append("page:\(page)")
        }
        return (sut, fields)
    }
}

final class RepoViewModelTests: XCTestCase {
    func testLoadNextPage_whenServiceIsSuccess_shouldAddRepos_shouldGetNames() {
        let (sut, fields) = makeSut()

        let repos = makeRepositories(count: 1)
        var mappedRepos = repos.map(\.displayModel)
        let login = repos[0].owner.login
        let user = UserModel(name: UUID().uuidString)

        var loadCompletion: RepositoriesCompletion?
        var userCompletion: UserInfoCompletion?

        fields.repositoriesService.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
            loadCompletion = completion
        }
        fields.userInfoServices.loadUserImpl = { [weak fields] login, completion in
            fields?.events.append("loadUser:\(login)")
            userCompletion = completion
        }

        XCTAssertEqual(sut.repositories, [])
        sut.loadNextPage()
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1"])
        XCTAssertEqual(sut.repositories, [])

        loadCompletion?(.success(.init(items: repos)))
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1", "loading:false",
                                       "tableLoading:false", "page:2", "reloadData",
                                       "loadUser:\(login)"])
        XCTAssertEqual(sut.repositories, mappedRepos)

        userCompletion?(.success(user))
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1", "loading:false",
                                       "tableLoading:false", "page:2", "reloadData",
                                       "loadUser:\(login)", "cell:0"])
        mappedRepos[0].fullName = user.name
        XCTAssertEqual(sut.repositories, mappedRepos)
    }

    func testLoadNextPage_whenCallingManyTimes_shouldDisplayTableLoading_shouldApendRepos() {
        let (sut, fields) = makeSut()
        let repos = makeRepositories(count: 1)
        var loadCompletion: RepositoriesCompletion?
        fields.repositoriesService.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
            loadCompletion = completion
        }
        fields.userInfoServices.loadUserImpl = { [weak fields] _, _ in
            fields?.events.append("loadName")
        }
        sut.loadNextPage()
        loadCompletion?(.success(.init(items: repos)))
        sut.loadNextPage()
        loadCompletion?(.success(.init(items: repos)))
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1", "loading:false",
                                       "tableLoading:false", "page:2", "reloadData", "loadName",
                                       "tableLoading:true", "loadPage:2", "loading:false",
                                       "tableLoading:false", "page:3", "reloadData", "loadName"])
        let mapped = (repos + repos).map(\.displayModel)
        XCTAssertEqual(sut.repositories, mapped)
    }

    func testLoadNextPage_whenServiceIsFailure_shouldDisplayAlert() {
        let (sut, fields) = makeSut()
        var loadCompletion: RepositoriesCompletion?
        fields.repositoriesService.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
            loadCompletion = completion
        }
        sut.loadNextPage()
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1"])
        loadCompletion?(.failure(.urlError))
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1", "loading:false",
                                       "tableLoading:false", "alert:\(AlertModel.errorAlert)"])
        XCTAssertEqual(sut.repositories, [])
    }

    func testDidSelectRow_whenWithRepositories_shouldSelectCorrectly() {
        let (sut, fields) = makeSut()
        let repos = makeRepositories(count: 10).map(\.displayModel)
        let row = Int.random(in: 0..<10)
        XCTAssertEqual(sut.repositories, [])
        sut.repositories = repos
        fields.coordinator.showPullRequestsViewImpl = { [weak fields] model in
            fields?.events.append("showPull")
            XCTAssertEqual(model, repos[row])
        }
        sut.didSelect(row: row)
        XCTAssertEqual(fields.events, ["showPull"])
    }

    func testReloadPage() {
        let (sut, fields) = makeSut()
        let page = Int.random(in: 1...10)
        sut.pageBox.value = page
        fields.repositoriesService.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
        }
        XCTAssertEqual(fields.events, ["page:\(page)"])
        sut.reloadPage()
        XCTAssertEqual(fields.events, ["page:\(page)", "page:1", "reloadData",
                                       "loading:true", "loadPage:1"])
    }
}

//
//  RepoViewModelTests.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 15/08/24.
//

import XCTest
@testable import GithubAPI

extension RepoViewModelTests {
    typealias Sut = RepositoriesViewModel

    final class Fields {
        var events: [String] = []

        let service = RepositoriesServiceMock()
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
                    login: UUID().uuidString,
                    name: nil
                )
            )
            repos.append(repo)
        }
        return repos
    }

    func makeSut() -> (Sut, Fields) {
        let fields = Fields()
        let sut = Sut(service: fields.service, coordinator: fields.coordinator)
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

        var repos = makeRepositories(count: 1)
        let login = repos[0].owner.login
        let user = UserModel(name: UUID().uuidString)

        var loadCompletion: RepositoriesCompletion?
        var nameCompletion: NameCompletion?

        fields.service.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
            loadCompletion = completion
        }
        fields.service.loadNameImpl = { [weak fields] login, completion in
            fields?.events.append("loadName:\(login)")
            nameCompletion = completion
        }

        XCTAssertEqual(sut.repositories, [])
        sut.loadNextPage()
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1"])
        XCTAssertEqual(sut.repositories, [])

        loadCompletion?(.success(.init(items: repos)))
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1", "loading:false",
                                       "tableLoading:false", "page:2", "reloadData",
                                       "loadName:\(login)"])
        XCTAssertEqual(sut.repositories, repos)

        nameCompletion?(.success(user))
        XCTAssertEqual(fields.events, ["loading:true", "loadPage:1", "loading:false",
                                       "tableLoading:false", "page:2", "reloadData",
                                       "loadName:\(login)", "cell:0"])
        repos[0].owner.name = user.name
        XCTAssertEqual(sut.repositories, repos)
    }

    func testLoadNextPage_whenCallingManyTimes_shouldDisplayTableLoading_shouldApendRepos() {
        let (sut, fields) = makeSut()
        let repos = makeRepositories(count: 1)
        var loadCompletion: RepositoriesCompletion?
        fields.service.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
            loadCompletion = completion
        }
        fields.service.loadNameImpl = { [weak fields] _, _ in
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
        XCTAssertEqual(sut.repositories, repos + repos)
    }

    func testLoadNextPage_whenServiceIsFailure_shouldDisplayAlert() {
        let (sut, fields) = makeSut()
        var loadCompletion: RepositoriesCompletion?
        fields.service.loadPageImpl = { [weak fields] page, completion in
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
        let repos = makeRepositories(count: 10)
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
        fields.service.loadPageImpl = { [weak fields] page, completion in
            fields?.events.append("loadPage:\(page)")
        }
        XCTAssertEqual(fields.events, ["page:\(page)"])
        sut.reloadPage()
        XCTAssertEqual(fields.events, ["page:\(page)", "page:1", "reloadData",
                                       "loading:true", "loadPage:1"])
    }
}

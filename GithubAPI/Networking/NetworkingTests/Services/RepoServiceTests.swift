//
//  RepoServiceTests.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
@testable import Networking

extension RepoServiceTests {
    typealias Sut = RepositoriesService

    final class Fields {
        var events: [String] = []

        let response = HTTPURLResponse(url: URL.cachesDirectory, statusCode: 200, httpVersion: nil, headerFields: nil)

        let dispacher = DispatcherMock()
        let jsonDecoder = JSONDecoderSpy()
    }

    func makeSut() -> (Sut, Fields) {
        let fields = Fields()
        fields.jsonDecoder.keyDecodingStrategyImpl = { [weak fields] key in
            fields?.events.append("decoderKey:\(key)")
        }
        let sut = Sut(dispacher: fields.dispacher, jsonDecoder: fields.jsonDecoder)
        fields.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return (sut, fields)
    }
}

final class RepoServiceTests: XCTestCase {
    func testLoadPage_whenReceiveValue_shouldDecodeProperly() throws {
        let (sut, fields) = makeSut()
        let page = Int.random(in: 1...99)
        let popularEndpoint = GitHubApiTarget(
            path: "/search/repositories",
            parameters: [
                "q": "language:Swift",
                "sort": "stars",
                "page": "\(page)"
            ]
        )
        let response = try XCTUnwrap(fields.response)
        var targetCompletion: TargetCompletion?
        fields.dispacher.callImpl = { [weak fields] endpoint, completion in
            fields?.events.append("call")
            XCTAssertEqual(endpoint as? GitHubApiTarget, popularEndpoint)
            targetCompletion = completion
            return nil
        }
        sut.loadPage(page) { [weak fields] result in
            fields?.events.append("load")
            XCTAssertNotNil(try? result.get())
        }
        XCTAssertEqual(fields.events, ["decoderKey:convertFromSnakeCase", "call"])
        targetCompletion?(.success((reposData, response)))
        XCTAssertEqual(fields.events, ["decoderKey:convertFromSnakeCase", "call", "load"])
    }
}

fileprivate let reposData = """
{
  "items": [
    {
      "id": 21700699,
      "name": "awesome-ios",
      "owner": {
        "login": "vsouza",
        "avatar_url": "https://avatars.githubusercontent.com/u/484656?v=4"
      },
      "description": "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects ",
      "stargazers_count": 46803,
      "forks_count": 6824
    }
  ]
}
""".data(using: .utf8) ?? Data()

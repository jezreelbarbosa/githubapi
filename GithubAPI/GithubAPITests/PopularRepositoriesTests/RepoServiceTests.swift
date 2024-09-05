//
//  RepoServiceTests.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
import Networking
@testable import GithubAPI

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
        return (sut, fields)
    }
}

final class RepoServiceTests: XCTestCase {
    func testLoadPage_whenReceiveValue_shouldDecodeProperly() throws {
        let (sut, fields) = makeSut()
        let page = Int.random(in: 1...99)
        let popularEndpoint = sut.swiftPopular(page: page)
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

    func testLoadName_whenReceiveValue_shouldDecodeProperly() throws {
        let (sut, fields) = makeSut()
        let login = UUID().uuidString
        let userEndpoint = sut.user(login: login)
        let response = try XCTUnwrap(fields.response)
        var targetCompletion: TargetCompletion?
        fields.dispacher.callImpl = { [weak fields] endpoint, completion in
            fields?.events.append("call")
            XCTAssertEqual(endpoint as? GitHubApiTarget, userEndpoint)
            targetCompletion = completion
            return nil
        }
        sut.loadName(with: login) { [weak fields] result in
            fields?.events.append("load")
            XCTAssertNotNil(try? result.get())
        }
        XCTAssertEqual(fields.events, ["decoderKey:convertFromSnakeCase", "call"])
        targetCompletion?(.success((userData, response)))
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

fileprivate let userData = """
{
  "name": "Vinicius Souza"
}
""".data(using: .utf8) ?? Data()

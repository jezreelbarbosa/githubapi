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
    func testLoadPage() {
        let (sut, fields) = makeSut()
        let page = Int.random(in: 1...99)
        let popularEndpoint = sut.swiftPopular(page: page)
        fields.dispacher.callImpl = { [weak fields] endpoint, completion in
            fields?.events.append("call")
            XCTAssertEqual(endpoint as? GitHubApiTarget, popularEndpoint)
            return nil
        }
        sut.loadPage(page) { _ in }
        XCTAssertEqual(fields.events, ["decoderKey:convertFromSnakeCase", "call"])
    }

    func testLoadName() {
        let (sut, fields) = makeSut()
        let login = UUID().uuidString
        let userEndpoint = sut.user(login: login)
        fields.dispacher.callImpl = { [weak fields] endpoint, completion in
            fields?.events.append("call")
            XCTAssertEqual(endpoint as? GitHubApiTarget, userEndpoint)
            return nil
        }
        sut.loadName(with: login) { _ in }
        XCTAssertEqual(fields.events, ["decoderKey:convertFromSnakeCase", "call"])
    }
}

final class DispatcherMock: Dispatching {
    var callImpl: (TargetType, TargetCompletion) -> URLSessionDataTask? = { _, _ in XCTFail(); return nil }
    func call(endpoint: TargetType, completion: @escaping TargetCompletion) -> URLSessionDataTask? {
        callImpl(endpoint, completion)
    }
}

final class JSONDecoderSpy: JSONDecoder {
    var keyDecodingStrategyImpl: (JSONDecoder.KeyDecodingStrategy) -> Void = { _ in XCTFail() }
    override var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        didSet { keyDecodingStrategyImpl(keyDecodingStrategy) }
    }
}

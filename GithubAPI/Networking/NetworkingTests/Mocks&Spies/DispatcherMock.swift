//
//  DispatcherMock.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 28/08/24.
//

import XCTest
import Networking

final class DispatcherMock: Dispatching {
    var callImpl: (TargetType, @escaping TargetCompletion) -> URLSessionDataTask? = { _, _ in XCTFail(); return nil }
    func call(endpoint: TargetType, completion: @escaping TargetCompletion) -> URLSessionDataTask? {
        callImpl(endpoint, completion)
    }
}

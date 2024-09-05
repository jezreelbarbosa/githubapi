//
//  JSONDecoderSpy.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 28/08/24.
//

import XCTest
import Networking

final class JSONDecoderSpy: JSONDecoder {
    var keyDecodingStrategyImpl: (JSONDecoder.KeyDecodingStrategy) -> Void = { _ in XCTFail() }
    override var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        didSet { keyDecodingStrategyImpl(keyDecodingStrategy) }
    }
}

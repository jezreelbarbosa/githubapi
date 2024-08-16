//
//  ServiceAPI.swift
//  Networking
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import Foundation

public typealias ServiceAPICompletion<T: Decodable> = (Result<T, TargetError>) -> Void

open class ServiceAPI {
    // Properties

    public let dispacher: Dispatching
    public let jsonDecoder: JSONDecoder

    public init(dispacher: Dispatching, jsonDecoder: JSONDecoder) {
        self.dispacher = dispacher
        self.jsonDecoder = jsonDecoder
    }

    public func makeRequest<T>(endpoint: TargetType, completion: @escaping ServiceAPICompletion<T>) {
        dispacher.call(endpoint: endpoint) { [weak jsonDecoder] result in
            guard let jsonDecoder = jsonDecoder else { return }
            switch result {
            case let .success((data, response)):
                do {
                    let model = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(.decodingError(data, response, error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

//
//  Dispatcher.swift
//  Networking
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

public typealias TargetCompletion = (Result<(data: Data, response: HTTPURLResponse), TargetError>) -> Void

public protocol Dispatching {
    @discardableResult
    func call(endpoint: TargetType, completion: @escaping TargetCompletion) -> URLSessionDataTask?
}

public class Dispatcher: Dispatching {
    // Lifecycle

    public init() {}

    // Functions

    @discardableResult
    public func call(endpoint: TargetType, completion: @escaping TargetCompletion) -> URLSessionDataTask? {
        guard let request = makeURLRequest(endpoint: endpoint) else {
            completion(.failure(.urlError))
            return nil
        }

        let task = makeDataTask(request: request, completion: completion)
        task.resume()
        return task
    }

    func makeURLRequest(endpoint: TargetType) -> URLRequest? {
        let fullPath = endpoint.baseURL + endpoint.path + joinedParameters(from: endpoint.parameters)
        guard let urlString = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString)
        else { return nil }

        var request = URLRequest(url: url, cachePolicy: endpoint.cachePolicy)
        request.httpMethod = endpoint.method
        request.httpBody = endpoint.body
        if let headers = endpoint.headers {
            headers.forEach { header in
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        return request
    }

    func makeDataTask(request: URLRequest, completion: @escaping TargetCompletion) -> URLSessionDataTask {
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.handle(data: data, response: response, error: error, completion: completion)
        }
    }

    func handle(data: Data?, response: URLResponse?, error: Error?, completion: @escaping TargetCompletion) {
        if let error = error {
            completion(.failure(.requestError(data, response, error)))
            return
        }

        guard let data = data, let response = response as? HTTPURLResponse else {
            completion(.failure(.unknowError(data, response, error)))
            return
        }

        switch response.statusCode {
        case 200...299:
            completion(.success((data, response)))
        case 300...399:
            completion(.success((data, response)))
        case 400...499:
            completion(.failure(.clientError(data, response)))
        case 500...599:
            completion(.failure(.serverError(data, response)))
        default:
            completion(.failure(.unknowError(data, response, error)))
        }
    }

    func joinedParameters(from parameters: [String: Any]?) -> String {
        guard let parameters = parameters else { return "" }
        return "?" + parameters.map({ $0.key + "=" + "\($0.value)" }).joined(separator: "&")
    }
}

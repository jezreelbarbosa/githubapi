//
//  RepositoriesService.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Networking

protocol RepositoriesServicing {
    func loadPage(_ page: Int, completion: @escaping (Result<[RepositoryModel], TargetError>) -> Void)
    func loadName(with login: String, completion: @escaping (Result<String?, TargetError>) -> Void)
}

extension RepositoriesService {
    func swiftPopular(page: Int) -> GitHubApiTarget {
        GitHubApiTarget(
            path: "/search/repositories",
            parameters: [
                "q": "language:Swift",
                "sort": "stars",
                "page": "\(page)"
            ]
        )
    }

    func user(login: String) -> GitHubApiTarget {
        GitHubApiTarget(path: "/users/\(login)")
    }
}

final class RepositoriesService: RepositoriesServicing {
    // Properties

    let dispatcher: Dispatching
    let decoder = JSONDecoder()

    // Lifecycle

    init(dispatcher: Dispatching) {
        self.dispatcher = dispatcher
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // functions

    func loadPage(_ page: Int, completion: @escaping (Result<[RepositoryModel], TargetError>) -> Void) {
        dispatcher.call(endpoint: swiftPopular(page: page)) { [weak self] result in
            result.successHandler { data, response in
                guard let model = try? self?.decoder.decode(RepositoriesModel.self, from: data) else {
                    completion(.failure(.jsonError(data, response)))
                    return
                }
                completion(.success(model.items))
            }
            result.failureHandler { error in
                completion(.failure(error))
            }
        }
    }

    func loadName(with login: String, completion: @escaping (Result<String?, TargetError>) -> Void) {
        dispatcher.call(endpoint: user(login: login)) { [weak self] result in
            result.successHandler { data, response in
                guard let model = try? self?.decoder.decode(UserModel.self, from: data) else {
                    completion(.failure(.jsonError(data, response)))
                    return
                }
                completion(.success(model.name))
            }
            result.failureHandler { error in
                completion(.failure(error))
            }
        }
    }
}

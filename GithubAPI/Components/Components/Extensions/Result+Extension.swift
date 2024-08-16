//
//  Result+Extension.swift
//  Components
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

public extension Result {
    @discardableResult
    func successHandler(_ handler: (Success) -> Void) -> Self {
        if case let .success(value) = self {
            handler(value)
        }
        return self
    }

    @discardableResult
    func failureHandler(_ handler: (Failure) -> Void) -> Self {
        if case let .failure(error) = self {
            handler(error)
        }
        return self
    }
}

//
//  Box.swift
//  Components
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

/// Implements a generic listener for an observed object
public final class Box<T> {
    // Observer

    public typealias Listener = (T) -> Void

    // Properties

    public var value: T {
        didSet { fire() }
    }

    private var listener: Listener?

    // Lifecycle

    public init(_ value: T) {
        self.value = value
    }

    // Functions

    public func bind(listener: Listener?) {
        self.listener = listener
    }

    public func fire() {
        listener?(value)
    }

    public func bindAndFire(listener: Listener?) {
        bind(listener: listener)
        fire()
    }
}

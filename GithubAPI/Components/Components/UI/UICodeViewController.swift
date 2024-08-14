//
//  UICodeViewController.swift
//  Components
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import UIKit

/// Implements generics for ViewModel and UIView
open class UICodeViewController<ViewModel, V: UIView>: UIViewController {
    // Properties

    public var viewModel: ViewModel
    public private(set) lazy var rootView = V()

    // Lifecycle

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }

    open override func loadView() {
        view = rootView
    }
}

//
//  UINavigationControllerSpy.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
import UIKit

final class UINavigationControllerSpy: UINavigationController {
    var pushViewControllerImpl: (UIViewController, Bool) -> Void = { _, _ in XCTFail() }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerImpl(viewController, animated)
    }
}

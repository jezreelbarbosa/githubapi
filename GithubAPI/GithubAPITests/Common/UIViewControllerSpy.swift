//
//  UIViewControllerSpy.swift
//  GithubAPITests
//
//  Created by Jezreel Barbosa on 16/08/24.
//

import XCTest
import UIKit

final class UIViewControllerSpy: UIViewController {
    var navigationControllerImpl: () -> UINavigationController? = { XCTFail(); return nil }
    override var navigationController: UINavigationController? {
        get { navigationControllerImpl() }
    }
}

//
//  UIActivityIndicatorView+Extension.swift
//  Components
//
//  Created by Jezreel Barbosa on 15/08/24.
//

import UIKit

public extension UIActivityIndicatorView {
    func animate(_ isAnimating: Bool) {
        DispatchQueue.main.async { [self] in
            if isAnimating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
}

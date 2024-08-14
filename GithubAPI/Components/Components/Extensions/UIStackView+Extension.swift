//
//  UIStackView+Extension.swift
//  Components
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import UIKit

extension UIStackView {
    @discardableResult
    public func addArrangedSubviews(_ arrengedSubviews: UIView...) -> Self {
        addArrangedSubviews(arrengedSubviews)
    }

    @discardableResult
    public func addArrangedSubviews(_ arrengedSubviews: [UIView]) -> Self {
        arrengedSubviews.forEach({ addArrangedSubview($0) })
        return self
    }
}

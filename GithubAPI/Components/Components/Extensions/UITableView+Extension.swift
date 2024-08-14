//
//  UITableView+Extension.swift
//  Components
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellReuseIdentifier: String(describing: cellClass))
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass)) as? T else {
            register(cellClass)
            return dequeueReusableCell(cellClass)
        }
        return cell
    }
}

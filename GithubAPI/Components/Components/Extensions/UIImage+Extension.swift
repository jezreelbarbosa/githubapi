//
//  UIImage+Extension.swift
//  Components
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import UIKit

extension UIImageView {
    @discardableResult
    public func setImage(from url: URL, completion: ((UIImage?) -> Void)? = nil) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Couldn't download data. Error: \(error?.localizedDescription ?? "Unknown")")
                completion?(nil)
                return
            }
            self?.setImage(from: data, completion: completion)
        }
        task.resume()
        return task
    }

    public func setImage(from data: Data, completion: ((UIImage?) -> Void)? = nil) {
        guard let image = UIImage(data: data) else {
            print("Couldn't load image from data")
            completion?(nil)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.image = image
            completion?(image)
        }
    }
}

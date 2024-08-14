//
//  ViewController.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 12/08/24.
//

import UIKit
import Stevia

class ViewController: UIViewController {

    let label = UILabel()

    let statsStack = UIStackView()
    let forkImageView = UIImageView()
    let forkLabel = UILabel()
    let starImageView = UIImageView()
    let starLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.sv(label)
//        label.centerInContainer()
//        label.style { s in
//            s.font = .systemFont(ofSize: 17, weight: .bold)
//            s.text = "􀋃 170 Hello, friend!"
//            s.textColor = .yellow
//        }
        view.style { s in
            s.backgroundColor = .white
        }

        view.sv(statsStack)
        statsStack.addArrangedSubviews(
            forkImageView,
            forkLabel,
            starImageView,
            starLabel
        )
        statsStack.centerHorizontally().top(64)
        forkImageView.size(12)
        starImageView.size(12)
        statsStack.style { s in
            s.axis = .horizontal
            s.spacing = 2
            s.setCustomSpacing(8, after: forkLabel)
            s.alignment = .center
        }
        forkImageView.style { s in
            s.image = .init(named: "fork")
            s.contentMode = .scaleAspectFit
            s.tintColor = .orange
        }
        forkLabel.style { s in
            s.font = .systemFont(ofSize: 14, weight: .bold)
            s.textColor = .orange
            s.text = "640"
        }
        starImageView.style { s in
            s.image = .init(systemName: "star.fill")
            s.contentMode = .scaleAspectFit
            s.tintColor = .orange
        }
        starLabel.style { s in
            s.font = .systemFont(ofSize: 14, weight: .bold)
            s.textColor = .orange
            s.text = "98"
        }
    }
}

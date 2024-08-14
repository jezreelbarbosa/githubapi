//
//  RepositoryCell.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import UIKit
import Components
import Stevia

final class RepositoryCell: UITableViewCell {
    // Properties

    let infoStack = UIStackView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()

    let statsStack = UIStackView()
    let forkImageView = UIImageView()
    let forkLabel = UILabel()
    let starImageView = UIImageView()
    let starLabel = UILabel()

    let userStack = UIStackView()
    let userImageView = UIImageView()
    let userNickNameLabel = UILabel()
    let userFullNameLabel = UILabel()

    // Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        initLayout()
        initStyle()
    }

    required init?(coder: NSCoder) { nil }

    private func initSubview() {
        contentView.sv(
            infoStack.addArrangedSubviews(
                nameLabel,
                descriptionLabel,
                statsStack.addArrangedSubviews(
                    forkImageView,
                    forkLabel,
                    starImageView,
                    starLabel
                )
            ),
            userStack.addArrangedSubviews(
                userImageView,
                userNickNameLabel,
                userFullNameLabel
            )
        )
    }

    private func initLayout() {
        infoStack.centerVertically().top(>=16).bottom(>=16).leading(16).width(60%).Trailing == userStack.Leading - 16
        userStack.centerVertically().top(>=16).bottom(>=16).trailing(16)
        forkImageView.size(12)
        starImageView.size(12)
        userImageView.size(36)
    }

    private func initStyle() {
        infoStack.style { s in
            s.axis = .vertical
            s.spacing = 4
            s.setCustomSpacing(8, after: descriptionLabel)
            s.alignment = .leading
        }
        nameLabel.style { s in
            s.font = .systemFont(ofSize: 15, weight: .semibold)
            s.textColor = .blue
        }
        descriptionLabel.style { s in
            s.font = .systemFont(ofSize: 12, weight: .regular)
            s.textColor = .black
            s.numberOfLines = 2
        }

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
        }
        starImageView.style { s in
            s.image = .init(named: "star.fill")
            s.contentMode = .scaleAspectFit
            s.tintColor = .orange
        }
        starLabel.style { s in
            s.font = .systemFont(ofSize: 14, weight: .bold)
            s.textColor = .orange
        }

        userStack.style { s in
            s.axis = .vertical
            s.spacing = 2
            s.alignment = .center
            s.distribution = .fill
        }
        userImageView.style { s in
            s.image = .init(named: "person.fill")
            s.contentMode = .scaleAspectFit
            s.tintColor = .lightGray
            s.layer.masksToBounds = true
            s.layer.cornerRadius = 18
        }
        userNickNameLabel.style { s in
            s.font = .systemFont(ofSize: 12, weight: .regular)
            s.textColor = .blue
        }
        userFullNameLabel.style { s in
            s.font = .systemFont(ofSize: 12, weight: .regular)
            s.textColor = .gray
        }
    }

    // Functions

    func setContent(model: RepositoryModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        forkLabel.text = "\(model.forksCount)"
        starLabel.text = "\(model.stargazersCount)"
        userNickNameLabel.text = model.owner.login
        userFullNameLabel.text = model.owner.name
        if let url = model.owner.avatarUrl {
            userImageView.setImage(from: url)
        } else {
            userImageView.image = .init(named: "person.fill")
        }
    }
}

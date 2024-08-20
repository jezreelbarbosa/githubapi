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

    let contentStack = UIStackView()
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
            contentStack.addArrangedSubviews(
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
        )
    }

    private func initLayout() {
        contentStack.fillContainer(16)
        userStack.width(104)
        forkImageView.size(12)
        starImageView.size(12)
        userImageView.size(36)
    }

    private func initStyle() {
        style { s in
            s.backgroundColor = .tertiarySystemBackground
            s.isAccessibilityElement = true
            s.accessibilityTraits = .button
        }
        contentStack.style { s in
            s.axis = .horizontal
            s.spacing = 16
            s.alignment = .center
        }
        infoStack.style { s in
            s.axis = .vertical
            s.spacing = 4
            s.setCustomSpacing(8, after: descriptionLabel)
            s.alignment = .leading
        }
        nameLabel.style { s in
            s.font = .preferredFont(forTextStyle: .headline)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .systemBlue
        }
        descriptionLabel.style { s in
            s.font = .preferredFont(forTextStyle: .caption1)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .label
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
            s.tintColor = .systemOrange
        }
        forkLabel.style { s in
            s.font = .preferredFont(forTextStyle: .footnote)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .systemOrange
        }
        starImageView.style { s in
            s.image = .init(named: "star.fill")
            s.contentMode = .scaleAspectFit
            s.tintColor = .systemOrange
        }
        starLabel.style { s in
            s.font = .preferredFont(forTextStyle: .footnote)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .systemOrange
        }

        userStack.style { s in
            s.axis = .vertical
            s.spacing = 2
            s.alignment = .center
        }
        userImageView.style { s in
            s.image = .init(named: "person.fill")
            s.contentMode = .scaleAspectFit
            s.tintColor = .systemGray
            s.layer.masksToBounds = true
            s.layer.cornerRadius = 18
        }
        userNickNameLabel.style { s in
            s.font = .preferredFont(forTextStyle: .caption1)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .systemBlue
        }
        userFullNameLabel.style { s in
            s.font = .preferredFont(forTextStyle: .caption2)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .systemGray
        }
    }

    // Functions

    func setContent(model: RepositoryModel) {
        nameLabel.text = model.name
        forkLabel.text = "\(model.forksCount)"
        starLabel.text = "\(model.stargazersCount)"
        userNickNameLabel.text = model.owner.login

        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description

        userFullNameLabel.isHidden = model.owner.name == nil
        userFullNameLabel.text = model.owner.name

        if let url = model.owner.avatarUrl {
            userImageView.setImage(from: url)
        } else {
            userImageView.image = .init(named: "person.fill")
        }

        let accDescription = "\(model.name). \(model.description ?? ""). "
        let accCount = "\(model.forksCount) Forks. \(model.stargazersCount) Stars. "
        let accUser = "From \(model.owner.name ?? model.owner.login)"
        accessibilityLabel = accDescription + accCount + accUser
    }
}

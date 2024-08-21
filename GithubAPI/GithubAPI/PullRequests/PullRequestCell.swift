//
//  PullRequestCell.swift
//  GithubAPI
//
//  Created by Jezreel Barbosa on 14/08/24.
//

import UIKit
import Components
import Stevia

final class PullRequestCell: UITableViewCell {
    // Properties

    let contentStack = UIStackView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()

    let userInfoStack = UIStackView()
    let userImageView = UIImageView()
    let userNameStack = UIStackView()
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
                titleLabel,
                descriptionLabel,
                dateLabel,
                userInfoStack.addArrangedSubviews(
                    userImageView,
                    userNameStack.addArrangedSubviews(
                        userNickNameLabel,
                        userFullNameLabel
                    )
                )
            )
        )
    }

    private func initLayout() {
        contentStack.fillContainer(16)
        userImageView.size(24)
    }

    private func initStyle() {
        style { s in
            s.backgroundColor = .tertiarySystemBackground
            s.isAccessibilityElement = true
            s.accessibilityTraits = .button
        }
        contentStack.style { s in
            s.axis = .vertical
            s.spacing = 4
            s.alignment = .leading
        }
        titleLabel.style { s in
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
        dateLabel.style { s in
            s.font = .preferredFont(forTextStyle: .caption1)
            s.adjustsFontForContentSizeCategory = true
            s.textColor = .systemOrange
        }

        userInfoStack.style { s in
            s.axis = .horizontal
            s.spacing = 8
            s.alignment = .center
        }
        userImageView.style { s in
            s.image = .init(named: "person.fill")
            s.contentMode = .scaleAspectFit
            s.tintColor = .systemGray
            s.layer.masksToBounds = true
            s.layer.cornerRadius = 12
        }
        userNameStack.style { s in
            s.axis = .vertical
            s.spacing = 2
            s.alignment = .leading
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

    func setContent(model: PullRequestModel) {
        titleLabel.text = model.title
        dateLabel.text = model.createdAt.formatted(date: .medium, time: .none)
        userNickNameLabel.text = model.user.login

        descriptionLabel.isHidden = model.body == nil
        descriptionLabel.text = model.body

        userFullNameLabel.isHidden = model.user.name == nil
        userFullNameLabel.text = model.user.name

        if let url = model.user.avatarUrl {
            userImageView.setImage(from: url)
        } else {
            userImageView.image = .init(named: "person.fill")
        }

        let accDescription = "\(model.title). "
        let accDate = "Created at \(model.createdAt.formatted(date: .long, time: .none)). "
        let accUser = "From \(model.user.name ?? model.user.login)"
        accessibilityLabel = accDescription + accDate + accUser
    }
}

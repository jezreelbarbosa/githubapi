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
    let userNameLabel = UILabel()
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
                        userNameLabel,
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
        userNameLabel.style { s in
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

    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = .init(named: "person.fill")
    }

    // Functions

    func setContent(model: PullRequestDisplayModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        userNameLabel.text = model.username

        descriptionLabel.isHidden = model.body == nil
        descriptionLabel.text = model.body

        userFullNameLabel.isHidden = model.fullname == nil
        userFullNameLabel.text = model.fullname

        if let url = model.avatarUrl {
            userImageView.setImage(from: url)
        }
        accessibilityLabel = model.accessibilityLabel
    }
}

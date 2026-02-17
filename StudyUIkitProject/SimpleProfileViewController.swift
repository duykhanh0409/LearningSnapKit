//
//  SimpleProfileViewController.swift
//  StudyUIkitProject
//
//  Created by Khanh Nguyen on 16/2/26.
//

import UIKit
import SnapKit

class SimpleProfileViewController: UIViewController {

    // MARK: - UI Components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .systemBlue
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .white
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Khanh Nguyen"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer | Learning UIKit with SnapKit"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.backgroundColor = .gray
        return stack
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Profile khanh"

        // Add all subviews
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(bioLabel)
        view.addSubview(statsStackView)
        view.addSubview(editButton)
        view.addSubview(followButton)

        // Add stat views to stack
        statsStackView.addArrangedSubview(createStatView(number: "128", label: "Posts"))
        statsStackView.addArrangedSubview(createStatView(number: "1.2K", label: "Followers"))
        statsStackView.addArrangedSubview(createStatView(number: "350", label: "Following"))
    }

    private func setupConstraints() {
        // Profile Image - centered at top
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }

        // Name Label - below profile image
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        // Bio Label - below name
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        // Stats Stack View - below bio
        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }

        // Edit Button - below stats
        editButton.snp.makeConstraints { make in
            make.top.equalTo(statsStackView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // Follow Button - below edit button
        followButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    private func setupActions() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
    }

    // MARK: - Helper Methods

    private func createStatView(number: String, label: String) -> UIView {
        let container = UIView()

        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = .systemFont(ofSize: 20, weight: .bold)
        numberLabel.textAlignment = .center

        let textLabel = UILabel()
        textLabel.text = label
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        textLabel.textColor = .secondaryLabel
        textLabel.textAlignment = .center

        container.addSubview(numberLabel)
        container.addSubview(textLabel)

        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        return container
    }

    // MARK: - Actions

    @objc private func editButtonTapped() {
        let alert = UIAlertController(
            title: "Edit Profile",
            message: "Edit profile functionality coming soon!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func followButtonTapped() {
        // Toggle follow state
        let isFollowing = followButton.titleLabel?.text == "Following"

        if isFollowing {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .systemGray6
            followButton.setTitleColor(.label, for: .normal)
        } else {
            followButton.setTitle("Following", for: .normal)
            followButton.backgroundColor = .systemBlue
            followButton.setTitleColor(.white, for: .normal)
        }

        // Animate button
        UIView.animate(withDuration: 0.2) {
            self.followButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.followButton.transform = .identity
            }
        }
    }
}

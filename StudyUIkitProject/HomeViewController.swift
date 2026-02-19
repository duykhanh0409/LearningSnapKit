//
//  HomeViewController.swift
//  StudyUIkitProject
//
//  UIKit Learning Hub - List of topics to explore
//  Created by Khanh Nguyen on 18/2/26.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    // MARK: - UI Components

    private let headerView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UIKit Learning Hub"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore UIKit concepts with interactive demos"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TopicCell.self, forCellReuseIdentifier: "TopicCell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        return table
    }()

    // MARK: - Data Model

    private let topics: [LearningTopic] = [
        // MARK: - Completed Topics
        LearningTopic(
            title: "Auto Layout & StackView",
            description: "Dynamic height with API simulation",
            icon: "arrow.down.circle.fill",
            color: .systemBlue,
            status: .completed,
            viewController: { APIStackViewController() }
        ),
        LearningTopic(
            title: "Expandable Cards",
            description: "StackView with expand/collapse animations",
            icon: "rectangle.stack.fill",
            color: .systemPurple,
            status: .completed,
            viewController: { DynamicStackViewController() }
        ),
        LearningTopic(
            title: "Profile Layout",
            description: "Static layout with SnapKit constraints",
            icon: "person.circle.fill",
            color: .systemGreen,
            status: .completed,
            viewController: { SimpleProfileViewController() }
        ),

        // MARK: - Coming Soon
        LearningTopic(
            title: "UITableView Basics",
            description: "Lists, cell reuse, and data sources",
            icon: "list.bullet",
            color: .systemOrange,
            status: .completed,
            viewController: { UITableViewBasicsViewController() }
        ),
        LearningTopic(
            title: "TableView API Demo",
            description: "Compare TableView vs StackView for dynamic content",
            icon: "list.bullet.rectangle",
            color: .systemTeal,
            status: .completed,
            viewController: { APITableViewDemoViewController() }
        ),

        // MARK: - Coming Soon
        LearningTopic(
            title: "UICollectionView",
            description: "Grid layouts and custom flows",
            icon: "square.grid.3x3.fill",
            color: .systemPink,
            status: .comingSoon,
            viewController: nil
        ),
        LearningTopic(
            title: "Custom Views",
            description: "Building reusable UI components",
            icon: "paintbrush.fill",
            color: .systemIndigo,
            status: .comingSoon,
            viewController: nil
        ),
        LearningTopic(
            title: "Animations",
            description: "UIView animations and transitions",
            icon: "sparkles",
            color: .systemYellow,
            status: .comingSoon,
            viewController: nil
        ),
        LearningTopic(
            title: "Gestures & Touch",
            description: "Tap, swipe, pinch, and pan gestures",
            icon: "hand.tap.fill",
            color: .systemTeal,
            status: .comingSoon,
            viewController: nil
        ),
        LearningTopic(
            title: "ScrollView Deep Dive",
            description: "Mastering UIScrollView and content size",
            icon: "scroll.fill",
            color: .systemRed,
            status: .comingSoon,
            viewController: nil
        ),
        LearningTopic(
            title: "Navigation Patterns",
            description: "Push, present, and custom transitions",
            icon: "arrow.right.circle.fill",
            color: .systemBrown,
            status: .comingSoon,
            viewController: nil
        ),
        LearningTopic(
            title: "Auto Layout Debugging",
            description: "Understanding and fixing constraint conflicts",
            icon: "wrench.and.screwdriver.fill",
            color: .systemGray,
            status: .comingSoon,
            viewController: nil
        )
    ]

    private var completedTopics: [LearningTopic] {
        topics.filter { $0.status == .completed }
    }

    private var comingSoonTopics: [LearningTopic] {
        topics.filter { $0.status == .comingSoon }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Home"

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? completedTopics.count : comingSoonTopics.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "✅ Ready to Explore (\(completedTopics.count))"
        } else {
            return "🔜 Coming Soon (\(comingSoonTopics.count))"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as? TopicCell else {
            return UITableViewCell()
        }

        let topic = indexPath.section == 0 ? completedTopics[indexPath.row] : comingSoonTopics[indexPath.row]
        cell.configure(with: topic)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let topic = indexPath.section == 0 ? completedTopics[indexPath.row] : comingSoonTopics[indexPath.row]

        if let viewController = topic.viewController?() {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            showComingSoonAlert(for: topic)
        }
    }

    private func showComingSoonAlert(for topic: LearningTopic) {
        let alert = UIAlertController(
            title: "🔜 Coming Soon",
            message: "\(topic.title) will be added in future updates!\n\nStay tuned for more UIKit learning content.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Learning Topic Model

struct LearningTopic {
    let title: String
    let description: String
    let icon: String
    let color: UIColor
    let status: TopicStatus
    let viewController: (() -> UIViewController)?

    enum TopicStatus {
        case completed
        case comingSoon
    }
}

// MARK: - Topic Cell

class TopicCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()

    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(chevronImageView)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }

        iconContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(28)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(iconContainerView.snp.right).offset(12)
            make.right.equalTo(chevronImageView.snp.left).offset(-8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-16)
        }

        statusLabel.snp.makeConstraints { make in
            make.right.equalTo(chevronImageView.snp.left).offset(-8)
            make.centerY.equalTo(iconContainerView)
        }

        chevronImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }

    func configure(with topic: LearningTopic) {
        iconContainerView.backgroundColor = topic.color
        iconImageView.image = UIImage(systemName: topic.icon)
        titleLabel.text = topic.title
        descriptionLabel.text = topic.description

        switch topic.status {
        case .completed:
            statusLabel.text = "✅"
            statusLabel.textColor = .systemGreen
            chevronImageView.isHidden = false
        case .comingSoon:
            statusLabel.text = "🔜"
            statusLabel.textColor = .systemOrange
            chevronImageView.isHidden = true
        }
    }
}

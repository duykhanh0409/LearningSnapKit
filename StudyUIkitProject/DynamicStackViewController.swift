//
//  DynamicStackViewController.swift
//  StudyUIkitProject
//
//  Created by Khanh Nguyen on 18/2/26.
//

import UIKit
import SnapKit

class DynamicStackViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dynamic Stack Demo"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap any card to expand/collapse. Stack view tự động adjust height!"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill  // Important: .fill để views tự tính height
        stack.alignment = .fill
        return stack
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New Card", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    // MARK: - Properties

    private var cards: [ExpandableCardView] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        createInitialCards()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Auto Layout Demo"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(addButton)
    }

    private func setupConstraints() {
        // ScrollView - full screen
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // ContentView - width cố định, height dynamic
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            // Height sẽ tự động dựa trên content bên trong
        }

        // Title
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        // Description
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        // StackView - KEY: không set height, để nó tự tính!
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }

        // Add Button
        addButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)  // Pin bottom để content view có height
        }
    }

    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    private func createInitialCards() {
        let cardData = [
            ("User Profile", "Name: Khanh Nguyen\nEmail: khanh@example.com\nPhone: +84 123 456 789\nAddress: Ho Chi Minh City, Vietnam"),
            ("Project Info", "Project: UIKit Study\nStatus: In Progress\nFramework: SnapKit\nLanguage: Swift 5.9"),
            ("Skills", "iOS Development\nUIKit & SwiftUI\nAuto Layout & SnapKit\nMVVM Architecture\nCore Data & Realm"),
            ("Experience", "5 years iOS Development\nPublished 10+ apps\nApp Store featured apps\nLead iOS Developer"),
            ("Education", "Computer Science Degree\niOS Bootcamp Graduate\nSwift Certified Developer\nMobile Architecture Expert"),
            ("Hobbies", "Learning new technologies\nBuilding side projects\nContributing to open source\nTeaching iOS development")
        ]

        for (index, data) in cardData.enumerated() {
            let card = ExpandableCardView(title: data.0, content: data.1)
            card.tag = index
            card.onTap = { [weak self] cardView in
                self?.toggleCard(cardView)
            }
            cards.append(card)
            stackView.addArrangedSubview(card)
        }
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        let newIndex = cards.count + 1
        let card = ExpandableCardView(
            title: "New Card #\(newIndex)",
            content: "This is a dynamically added card.\nIt demonstrates how StackView automatically adjusts its height.\nYou can add as many cards as you want!"
        )
        card.tag = cards.count
        card.onTap = { [weak self] cardView in
            self?.toggleCard(cardView)
        }

        cards.append(card)
        stackView.addArrangedSubview(card)

        // Animate insertion
        card.alpha = 0
        card.transform = CGAffineTransform(translationX: 0, y: -20)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            card.alpha = 1
            card.transform = .identity
            self.view.layoutIfNeeded()
        }

        // Scroll to new card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollView.scrollRectToVisible(card.frame, animated: true)
        }
    }

    private func toggleCard(_ card: ExpandableCardView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            card.toggleExpanded()
            // Magic: Stack view tự động adjust height khi card expand/collapse!
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Expandable Card View

class ExpandableCardView: UIView {

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        return view
    }()

    private let headerView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0  // Important: 0 = unlimited lines
        return label
    }()

    // MARK: - Properties

    private var isExpanded = false
    var onTap: ((ExpandableCardView) -> Void)?

    // MARK: - Initialization

    init(title: String, content: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        contentLabel.text = content
        setupUI()
        setupConstraints()
        setupGesture()

        // Initial state: collapsed
        contentLabel.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(contentLabel)

        headerView.addSubview(titleLabel)
        headerView.addSubview(chevronImageView)
    }

    private func setupConstraints() {
        // Container - full width
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Header
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(56)
        }

        // Title
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(chevronImageView.snp.left).offset(-12)
        }

        // Chevron
        chevronImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        // Content Label - KEY: pin to bottom để card tự tính height!
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)  // Pin bottom!
        }
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        headerView.addGestureRecognizer(tapGesture)
        headerView.isUserInteractionEnabled = true
    }

    // MARK: - Actions

    @objc private func cardTapped() {
        onTap?(self)
    }

    func toggleExpanded() {
        isExpanded.toggle()
        contentLabel.isHidden = !isExpanded

        // Rotate chevron
        let rotation: CGFloat = isExpanded ? .pi : 0
        chevronImageView.transform = CGAffineTransform(rotationAngle: rotation)

        // Change background color
        containerView.backgroundColor = isExpanded ? .tertiarySystemBackground : .secondarySystemBackground
    }
}

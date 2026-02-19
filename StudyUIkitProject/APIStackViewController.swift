//
//  APIStackViewController.swift
//  StudyUIkitProject
//
//  Created by Khanh Nguyen on 18/2/26.
//

import UIKit
import SnapKit

class APIStackViewController: UIViewController {

    // MARK: - UI Components

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "StackView Bottom Sheet"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Bottom sheet pinned at bottom 📍\nDynamic cells will expand UPWARD ⬆️"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reload API", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    // ⭐ Stack View - Bottom Sheet Style
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .fill
        stack.backgroundColor = .systemBackground
        stack.layer.cornerRadius = 20
        stack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]  // Top corners only
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    // MARK: - Properties

    // Static cells - luôn hiển thị
    private let staticCells: [CellData] = [
        CellData(title: "Profile", subtitle: "User information", color: .systemBlue),
        CellData(title: "Settings", subtitle: "App preferences", color: .systemGreen),
        CellData(title: "Help", subtitle: "Support & FAQ", color: .systemOrange)
    ]

    // Dynamic cells - show sau API response
    private let dynamicCells: [CellData] = [
        CellData(title: "Recent Orders", subtitle: "Last 30 days orders from API", color: .systemPurple),
        CellData(title: "Recommendations", subtitle: "Personalized suggestions from API", color: .systemPink)
    ]

    private var dynamicCellViews: [CellView] = []
    private var isAPILoaded = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        createStaticCells()
        createDynamicCells()

        // Update height label sau khi layout
        DispatchQueue.main.async {
            self.updateHeightLabel()
        }

        // Simulate API call sau 2 giây
        simulateAPICall()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeightLabel()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "StackView Version"

        // Bottom sheet layout
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(heightLabel)
        view.addSubview(reloadButton)
        view.addSubview(mainStackView)  // StackView last (on top visually)
    }

    private func setupConstraints() {
        // Background - full screen
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Title - at top
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        // Status - below title
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        // Height Label - below status
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        // Reload Button - below height label
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // ⭐ StackView: PINNED TO BOTTOM (expands UPWARD)
        mainStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)  // ⭐ Pin to BOTTOM
            // No height constraint - intrinsic content size
        }
    }

    private func setupActions() {
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }

    private func createStaticCells() {
        // Add header first
//        headerLabel.text = "📍 \(staticCells.count) Cells Fixed at Bottom"
//        headerLabel.textColor = .systemOrange
//        mainStackView.addArrangedSubview(headerLabel)

        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        // Add static cells
        for cellData in staticCells {
            let cell = CellView(data: cellData, isStatic: true)
            mainStackView.addArrangedSubview(cell)

            // Cell height constraint
            cell.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
    }

    private func updateHeader() {
//        let dynamicCount = dynamicCellViews.filter { !$0.isHidden }.count
//        if dynamicCount > 0 {
//            headerLabel.text = "⬆️ \(dynamicCount) Dynamic Cells | \(staticCells.count) Fixed Below"
//            headerLabel.textColor = .systemGreen
//        } else {
//            headerLabel.text = "📍 \(staticCells.count) Cells Fixed at Bottom"
//            headerLabel.textColor = .systemOrange
//        }
    }

    private func createDynamicCells() {
        // Don't add dynamic cells yet - will be inserted at top when API loads
        for cellData in dynamicCells {
            let cell = CellView(data: cellData, isStatic: false)
            cell.isHidden = true
            cell.alpha = 0
            dynamicCellViews.append(cell)
        }
    }

    // MARK: - API Simulation

    private func simulateAPICall() {
        statusLabel.text = "⏳ Loading API in 2s...\nWatch bottom sheet EXPAND UPWARD ⬆️"
        statusLabel.textColor = .secondaryLabel
        reloadButton.isEnabled = false
        reloadButton.alpha = 0.5

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showDynamicCells()
        }
    }

    private func showDynamicCells() {
        isAPILoaded = true
        statusLabel.text = "✅ Loading! Watch sheet EXPAND UPWARD ⬆️"
        statusLabel.textColor = .systemGreen
        reloadButton.isEnabled = true
        reloadButton.alpha = 1.0

        // ⭐ Insert cells at TOP (index 0) in reverse order
        let reversedCells = Array(dynamicCellViews.reversed())

        for (index, cell) in reversedCells.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) { [weak self] in
                guard let self = self else { return }

                // ⭐ Insert at TOP of StackView (index 0)
                // This pushes static cells DOWN
                self.mainStackView.insertArrangedSubview(cell, at: 0)

                // Setup height constraint
                cell.snp.makeConstraints { make in
                    make.height.equalTo(80)
                }

                // Initial transform (from above)
                cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                    .translatedBy(x: 0, y: -20)
                cell.isHidden = false
                cell.alpha = 0

                // Animate entrance
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.4,
                    options: [.curveEaseOut]
                ) {
                    cell.transform = .identity
                    cell.alpha = 1.0
                    // ⭐ StackView expands UPWARD (because pinned to bottom)
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.updateHeightLabel()
//                    self.updateHeader()

                    // Final status
                    if index == reversedCells.count - 1 {
                        self.statusLabel.text = "✅ Complete! Bottom sheet expanded ⬆️"
                    }
                }
            }
        }
    }

    private func updateHeightLabel() {
        let height = mainStackView.frame.height
        let staticCount = staticCells.count
        let dynamicCount = dynamicCellViews.filter { !$0.isHidden }.count

        let metricsText = """
        📊 Bottom Sheet Metrics:
        Total: \(staticCount + dynamicCount) (\(dynamicCount) dynamic + \(staticCount) static)
        Height: \(Int(height)) px
        """

        heightLabel.text = metricsText
        heightLabel.textColor = dynamicCount > 0 ? .systemGreen : .systemOrange
    }

    // MARK: - Actions

    @objc private func reloadButtonTapped() {
        // Reset state
        isAPILoaded = false
        statusLabel.text = "Bottom sheet pinned at bottom 📍\nDynamic cells will expand UPWARD ⬆️"
        statusLabel.textColor = .secondaryLabel

        // Remove and hide dynamic cells with animation
        for cell in dynamicCellViews {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseIn]
            ) {
                cell.alpha = 0
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    .translatedBy(x: 0, y: -20)
                self.view.layoutIfNeeded()
            } completion: { _ in
                // Remove from StackView
                self.mainStackView.removeArrangedSubview(cell)
                cell.removeFromSuperview()
                cell.isHidden = true
                cell.transform = .identity

                self.updateHeightLabel()
//                self.updateHeader()
            }
        }

        // Simulate API again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.simulateAPICall()
        }
    }
}

// MARK: - Cell Data Model

struct CellData {
    let title: String
    let subtitle: String
    let color: UIColor
}

// MARK: - Cell View

class CellView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.12
        return view
    }()

    private let iconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 2
        return label
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    init(data: CellData, isStatic: Bool) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        configure(with: data, isStatic: isStatic)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(badgeLabel)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-8)
        }

        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalTo(badgeLabel.snp.left).offset(-8)
            make.top.equalToSuperview().offset(6)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }

        badgeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(20)
        }
    }

    private func configure(with data: CellData, isStatic: Bool) {
        // ⭐ Visual distinction for bottom sheet effect
        if isStatic {
            // Static cells - darker, at bottom
            containerView.backgroundColor = data.color.withAlphaComponent(0.6)
            badgeLabel.text = "BOTTOM"
            badgeLabel.backgroundColor = UIColor.systemGray.withAlphaComponent(0.8)
            badgeLabel.textColor = .white
        } else {
            // Dynamic cells - vibrant, expanding from top
            containerView.backgroundColor = data.color
            badgeLabel.text = "DYNAMIC"
            badgeLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
            badgeLabel.textColor = .white
        }

        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}

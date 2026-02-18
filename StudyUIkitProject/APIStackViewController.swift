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

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .systemGroupedBackground
        return scroll
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "API Loading Demo"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading API data in 2 seconds..."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    // Stack View với background color để thấy rõ bounds
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .fill
        stack.backgroundColor = .systemGray5  // Background để thấy stackView
        stack.layer.cornerRadius = 16
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "StackView Height: Calculating..."
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
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
        CellData(title: "Recommendations", subtitle: "Personalized suggestions from API", color: .systemPink),
        CellData(title: "Notifications", subtitle: "Unread messages from API", color: .systemRed)
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
//        simulateAPICall()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeightLabel()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "API Stack Demo"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(mainStackView)
        contentView.addSubview(heightLabel)
        contentView.addSubview(reloadButton)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        // ⭐ StackView: Không set height constraint - để tự động tính!
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            // Không có make.height - intrinsic content size!
        }

        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }

        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func setupActions() {
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }

    private func createStaticCells() {
        for cellData in staticCells {
            let cell = CellView(data: cellData)
            mainStackView.addArrangedSubview(cell)

            // Cell height constraint
            cell.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
    }

    private func createDynamicCells() {
        for cellData in dynamicCells {
            let cell = CellView(data: cellData)
            cell.isHidden = true  // ⭐ Hidden cells không chiếm space trong stackView!
            cell.alpha = 0  // Cho animation smooth
        
            dynamicCellViews.append(cell)
            mainStackView.addArrangedSubview(cell)
            // Cell height constraint
            cell.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
    }

    // MARK: - API Simulation

    private func simulateAPICall() {
        statusLabel.text = "⏳ Loading API data in 2 seconds..."
        reloadButton.isEnabled = false
        reloadButton.alpha = 0.5

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showDynamicCells()
        }
    }

    private func showDynamicCells() {
        isAPILoaded = true
        statusLabel.text = "✅ API data loaded! StackView expanded automatically"
        statusLabel.textColor = .systemGreen
        reloadButton.isEnabled = true
        reloadButton.alpha = 1.0

        // Show cells với animation
        for (index, cell) in dynamicCellViews.enumerated() {
            // Delay mỗi cell một chút để có hiệu ứng cascade
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                cell.isHidden = false  // ⭐ StackView tự động re-layout!

                // Animate fade in + slide
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                    cell.alpha = 1.0
                    // ⭐ Magic happens here: StackView height tự động tăng!
                    self.view.layoutIfNeeded()
                }

                // Update height label sau animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.updateHeightLabel()
                }
            }
        }
    }

    private func updateHeightLabel() {
        let height = mainStackView.frame.height
        heightLabel.text = String(format: "📏 StackView Height: %.0f px", height)

        // Thay đổi màu dựa trên height
        if height > 400 {
            heightLabel.textColor = .systemGreen
        } else {
            heightLabel.textColor = .systemOrange
        }
    }

    // MARK: - Actions

    @objc private func reloadButtonTapped() {
        // Reset state
        isAPILoaded = false
        statusLabel.textColor = .secondaryLabel

        // Hide dynamic cells
        for cell in dynamicCellViews {
            UIView.animate(withDuration: 0.2) {
                cell.alpha = 0
            } completion: { _ in
                cell.isHidden = true
                self.updateHeightLabel()
            }
        }

        // Simulate API again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
        view.layer.cornerRadius = 12
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 2
        return label
    }()

    init(data: CellData) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        configure(with: data)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }

    private func configure(with data: CellData) {
        containerView.backgroundColor = data.color
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}

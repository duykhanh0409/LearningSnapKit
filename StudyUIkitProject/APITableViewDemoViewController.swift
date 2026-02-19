//
//  APITableViewDemoViewController.swift
//  StudyUIkitProject
//
//  TableView version of API loading demo - Compare với StackView
//  Created by Khanh Nguyen on 18/2/26.
//

import UIKit
import SnapKit

class APITableViewDemoViewController: UIViewController {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TableView Dynamic Insert"
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

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(APITableCell.self, forCellReuseIdentifier: "APITableCell")
        table.rowHeight = 80
        // ⭐ Key: Disable scrolling - TableView acts like StackView
        table.isScrollEnabled = false
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.layer.cornerRadius = 20
        table.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]  // Top corners only
        table.clipsToBounds = true
        return table
    }()

    private let metricsLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
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

    // MARK: - Data Model

    // Static data - luôn hiển thị
    private let staticCells: [CellData] = [
        CellData(title: "Profile", subtitle: "User information", color: .systemBlue),
        CellData(title: "Settings", subtitle: "App preferences", color: .systemGreen),
        CellData(title: "Help", subtitle: "Support & FAQ", color: .systemOrange)
    ]

    // Dynamic data - show sau API response
    private let dynamicCells: [CellData] = [
        CellData(title: "Recent Orders", subtitle: "Last 30 days orders from API", color: .systemPurple),
        CellData(title: "Recommendations", subtitle: "Personalized suggestions from API", color: .systemPink)
    ]

    // Current data source
    private var displayedCells: [CellData] = []
    private var isAPILoaded = false

    // TableView height constraint for dynamic sizing
    private var tableViewHeightConstraint: Constraint?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        setupActions()

        // Initial data: only static cells
        displayedCells = staticCells
        tableView.reloadData()

        // Update initial height
        DispatchQueue.main.async {
            self.updateTableViewHeight(animated: false)
            self.updateMetrics()
        }

        // Simulate API call
        simulateAPICall()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMetrics()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Bottom Sheet Demo"

        // Bottom sheet layout
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(metricsLabel)
        view.addSubview(reloadButton)
        view.addSubview(tableView)  // TableView last (on top visually)
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

        // Metrics - below status
        metricsLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        // Reload Button - below metrics
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(metricsLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // ⭐ TableView: PINNED TO BOTTOM (expands UPWARD)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)  // ⭐ Pin to BOTTOM
            // Initial height for 3 static rows
            tableViewHeightConstraint = make.height.equalTo(280).constraint
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupActions() {
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }

    // MARK: - API Simulation

    private func simulateAPICall() {
        statusLabel.text = "⏳ Loading API in 2s...\nWatch bottom sheet EXPAND UPWARD ⬆️"
        statusLabel.textColor = .secondaryLabel
        reloadButton.isEnabled = false
        reloadButton.alpha = 0.5

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.loadDynamicData()
        }
    }

    private func loadDynamicData() {
        isAPILoaded = true
        statusLabel.text = "✅ Loading! Watch sheet EXPAND UPWARD ⬆️"
        statusLabel.textColor = .systemGreen
        reloadButton.isEnabled = true
        reloadButton.alpha = 1.0

        // ⭐ Insert from top to bottom - dynamic cells appear ABOVE static cells
        let reversedCells = Array(dynamicCells.reversed())

        for (index, cell) in reversedCells.enumerated() {
            // Delay each row by 0.2s for smoother animation
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) { [weak self] in
                guard let self = self else { return }

                // ⭐ Insert at INDEX 0 - Top of the list!
                // Static cells stay at bottom
                self.displayedCells.insert(cell, at: 0)

                let indexPath = IndexPath(row: 0, section: 0)

                // ⭐ Insert with TOP animation
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    // Update status when all done
                    if index == reversedCells.count - 1 {
                        self.statusLabel.text = "✅ Complete! Bottom sheet expanded ⬆️"
                    }
                }

                self.tableView.performBatchUpdates {
                    self.tableView.insertRows(at: [indexPath], with: .top)
                } completion: { _ in
                    // Calculate new height
                    let newHeight = self.tableView.contentSize.height

                    // ⭐ Smooth height expansion UPWARD
                    self.tableViewHeightConstraint?.update(offset: newHeight)

                    UIView.animate(
                        withDuration: 0.4,
                        delay: 0,
                        usingSpringWithDamping: 0.75,
                        initialSpringVelocity: 0.3,
                        options: [.curveEaseOut]
                    ) {
                        // ⭐ Because pinned to BOTTOM, expanding height = moves UP
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        self.updateMetrics()
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)  // Update header
                    }
                }

                CATransaction.commit()
            }
        }
    }

    private func updateTableViewHeight(animated: Bool = true) {
        // Calculate content height
        let contentHeight = tableView.contentSize.height

        // Update constraint
        tableViewHeightConstraint?.update(offset: contentHeight)

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }

    private func updateMetrics() {
        let tableViewHeight = tableView.frame.height
        let contentHeight = tableView.contentSize.height
        let rowCount = displayedCells.count
        let dynamicCount = rowCount - staticCells.count

        let metricsText = """
        📊 Bottom Sheet Metrics:
        Total Rows: \(rowCount) (\(dynamicCount) dynamic + \(staticCells.count) static)
        Height: \(Int(tableViewHeight)) px
        Pinned: BOTTOM (expands ⬆️ upward)
        """

        metricsLabel.text = metricsText
        metricsLabel.textColor = dynamicCount > 0 ? .systemGreen : .systemOrange
    }

    // MARK: - Actions

    @objc private func reloadButtonTapped() {
        // Reset state
        isAPILoaded = false
        statusLabel.textColor = .secondaryLabel

        // Dynamic cells are at TOP now (index 0, 1, ...)
        let dynamicCellCount = displayedCells.count - staticCells.count

        // Delete dynamic cells from top
        let indexPathsToDelete = (0..<dynamicCellCount).map {
            IndexPath(row: $0, section: 0)
        }

        // Keep only static cells
        displayedCells = staticCells

        // ⭐ Animate deletion and shrink height
        tableView.performBatchUpdates {
            tableView.deleteRows(at: indexPathsToDelete, with: .top)
        } completion: { [weak self] _ in
            // Shrink TableView height back to original
            self?.updateTableViewHeight(animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.updateMetrics()
                self?.simulateAPICall()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension APITableViewDemoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "APITableCell", for: indexPath) as? APITableCell else {
            return UITableViewCell()
        }

        let data = displayedCells[indexPath.row]

        // Dynamic cells are now at TOP (index 0, 1, ...)
        let dynamicCellCount = displayedCells.count - staticCells.count
        let isDynamic = indexPath.row < dynamicCellCount

        cell.configure(with: data, isStatic: !isDynamic)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dynamicCount = displayedCells.count - staticCells.count
        if dynamicCount > 0 {
            return "⬆️ \(dynamicCount) Dynamic | \(staticCells.count) Fixed at Bottom"
        } else {
            return "📍 \(staticCells.count) Cells Fixed at Bottom"
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center

        let dynamicCount = displayedCells.count - staticCells.count
        if dynamicCount > 0 {
            label.text = "⬆️ \(dynamicCount) Dynamic Cells | \(staticCells.count) Fixed Below"
            label.textColor = .systemGreen
        } else {
            label.text = "📍 \(staticCells.count) Cells Fixed at Bottom"
            label.textColor = .systemOrange
        }

        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - UITableViewDelegate

extension APITableViewDemoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = displayedCells[indexPath.row]

        // Dynamic cells are now at TOP (index 0, 1, ...)
        let dynamicCellCount = displayedCells.count - staticCells.count
        let isDynamic = indexPath.row < dynamicCellCount
        let type = isDynamic ? "Dynamic (from API)" : "Static"

        let alert = UIAlertController(
            title: cell.title,
            message: "Type: \(type)\nRow: \(indexPath.row)\nLayout: Dynamic cells on top ⬆️",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // ⭐ Animate cell appearance
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Only animate dynamic cells (at top, before static section)
        // Dynamic cells are now at index 0, 1, ... (before static)
        let dynamicCellCount = displayedCells.count - staticCells.count
        guard indexPath.row < dynamicCellCount else { return }

        // Initial state: scaled down + translated UP (coming from top)
        cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            .translatedBy(x: 0, y: -20)  // Negative = from above
        cell.alpha = 0

        // Animate to normal state
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.4,
            options: [.curveEaseOut]
        ) {
            cell.transform = .identity
            cell.alpha = 1.0
        }
    }
}

// MARK: - Custom TableView Cell

class APITableCell: UITableViewCell {

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
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
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

    func configure(with data: CellData, isStatic: Bool) {
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

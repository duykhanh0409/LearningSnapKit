//
//  UITableViewBasicsViewController.swift
//  StudyUIkitProject
//
//  UITableView fundamentals with practical examples
//  Created by Khanh Nguyen on 18/2/26.
//

import UIKit
import SnapKit

class UITableViewBasicsViewController: UIViewController {

    // MARK: - UI Components

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        // Register multiple cell types
        table.register(BasicCell.self, forCellReuseIdentifier: "BasicCell")
        table.register(SubtitleCell.self, forCellReuseIdentifier: "SubtitleCell")
        table.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        return table
    }()

    // MARK: - Data Model

    private var sections: [Section] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        loadData()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "UITableView Basics"

        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupTableView() {
        // ⭐ Core: Set delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func loadData() {
        sections = [
            // Section 1: Basic Cells
            Section(
                title: "Basic Cells",
                footer: "UITableViewCell with .default style",
                items: [
                    Item(title: "Simple Cell 1", type: .basic),
                    Item(title: "Simple Cell 2", type: .basic),
                    Item(title: "Simple Cell 3", type: .basic)
                ]
            ),

            // Section 2: Subtitle Cells
            Section(
                title: "Subtitle Cells",
                footer: "UITableViewCell with .subtitle style",
                items: [
                    Item(title: "Email", subtitle: "john@example.com", type: .subtitle),
                    Item(title: "Phone", subtitle: "+1 234 567 8900", type: .subtitle),
                    Item(title: "Address", subtitle: "123 Main St, City", type: .subtitle)
                ]
            ),

            // Section 3: Custom Cells
            Section(
                title: "Custom Cells",
                footer: "Custom UITableViewCell with SnapKit layout",
                items: [
                    Item(title: "Profile", subtitle: "Khanh Nguyen • iOS Developer", icon: "person.circle.fill", color: .systemBlue, type: .custom),
                    Item(title: "Settings", subtitle: "App preferences and configuration", icon: "gear", color: .systemGray, type: .custom),
                    Item(title: "Notifications", subtitle: "3 unread messages", icon: "bell.badge.fill", color: .systemRed, type: .custom)
                ]
            ),

            // Section 4: Interactive Cells
            Section(
                title: "Swipe Actions",
                footer: "Swipe left on cells to see actions",
                items: [
                    Item(title: "Swipe me left", subtitle: "Delete or Archive", type: .subtitle),
                    Item(title: "Swipe me too", subtitle: "Multiple actions available", type: .subtitle),
                    Item(title: "Try swiping", subtitle: "iOS standard pattern", type: .subtitle)
                ]
            ),

            // Section 5: Dynamic Data
            Section(
                title: "Dynamic Operations",
                footer: "Tap '+' button to add, swipe to delete",
                items: [
                    Item(title: "Item 1", type: .basic),
                    Item(title: "Item 2", type: .basic)
                ]
            )
        ]

        // Add toolbar with add button
        setupToolbar()
    }

    private func setupToolbar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItemTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }

    // MARK: - Actions

    @objc private func addItemTapped() {
        let itemCount = sections[4].items.count + 1
        let newItem = Item(title: "Item \(itemCount)", type: .basic)

        // ⭐ Animate insertion
        sections[4].items.append(newItem)

        let indexPath = IndexPath(row: sections[4].items.count - 1, section: 4)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource

extension UITableViewBasicsViewController: UITableViewDataSource {

    // ⭐ Required: Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    // ⭐ Required: Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    // ⭐ Required: Cell for row at indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]

        switch item.type {
        case .basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
            cell.configure(with: item)
            return cell

        case .subtitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath) as! SubtitleCell
            cell.configure(with: item)
            return cell

        case .custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
            cell.configure(with: item)
            return cell
        }
    }

    // ⭐ Optional: Section header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    // ⭐ Optional: Section footer title
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
}

// MARK: - UITableViewDelegate

extension UITableViewBasicsViewController: UITableViewDelegate {

    // ⭐ Handle cell tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].items[indexPath.row]
        showDetailAlert(for: item, at: indexPath)
    }

    // ⭐ Swipe actions (leading - right swipe)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Only for section 3 (Swipe Actions)
        guard indexPath.section == 3 else { return nil }

        let markAction = UIContextualAction(style: .normal, title: "Mark") { [weak self] _, _, completion in
            self?.showToast("Marked as read")
            completion(true)
        }
        markAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [markAction])
    }

    // ⭐ Swipe actions (trailing - left swipe)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Allow delete in sections 3 and 4
        guard indexPath.section == 3 || indexPath.section == 4 else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteItem(at: indexPath)
            completion(true)
        }

        let archiveAction = UIContextualAction(style: .normal, title: "Archive") { [weak self] _, _, completion in
            self?.showToast("Archived")
            completion(true)
        }
        archiveAction.backgroundColor = .systemOrange

        return UISwipeActionsConfiguration(actions: [deleteAction, archiveAction])
    }

    // ⭐ Row height (dynamic)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // MARK: - Helper Methods

    private func deleteItem(at indexPath: IndexPath) {
        sections[indexPath.section].items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    private func showDetailAlert(for item: Item, at indexPath: IndexPath) {
        let message = """
        Section: \(indexPath.section)
        Row: \(indexPath.row)
        Type: \(item.type)
        """

        let alert = UIAlertController(
            title: item.title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showToast(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
    }
}

// MARK: - Data Models

struct Section {
    let title: String
    let footer: String
    var items: [Item]
}

struct Item {
    let title: String
    var subtitle: String?
    var icon: String?
    var color: UIColor?
    let type: CellType

    init(title: String, subtitle: String? = nil, icon: String? = nil, color: UIColor? = nil, type: CellType) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.type = type
    }
}

enum CellType {
    case basic
    case subtitle
    case custom
}

// MARK: - Cell Implementations

// 1. Basic Cell
class BasicCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Item) {
        textLabel?.text = item.title
    }
}

// 2. Subtitle Cell
class SubtitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .detailButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Item) {
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
    }
}

// 3. Custom Cell with SnapKit
class CustomCell: UITableViewCell {

    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
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
        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(chevronImageView)
    }

    private func setupConstraints() {
        iconContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(iconContainerView.snp.right).offset(12)
            make.right.equalTo(chevronImageView.snp.left).offset(-8)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-12)
        }

        chevronImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }

    func configure(with item: Item) {
        iconContainerView.backgroundColor = item.color
        iconImageView.image = UIImage(systemName: item.icon ?? "star.fill")
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}

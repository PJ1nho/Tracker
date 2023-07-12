//
//  UnregularMenuTableView.swift
//  Tracker
//
//  Created by Тихтей  Павел on 03.07.2023.
//

import UIKit

protocol UnregularMenuTableViewDelegate: AnyObject {
    func didTapMenu(menuItem: NewUnregularMenu)
}

final class UnregularMenuTableView: UIView {
    
    weak var delegate: UnregularMenuTableViewDelegate?
    
    private var tableView = UITableView()
    private let showCategoryVC = "ShowCategoryVC"
    private let menu = NewUnregularMenu.allCases
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Interface
    
    func setupUI() {
        configureTableView()
        configureConstraints()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

    //MARK: - UITableViewDataSource

extension UnregularMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row].rawValue
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}

    //MARK: - UITableViewDelegate

extension UnregularMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menu[indexPath.row]
        delegate?.didTapMenu(menuItem: menuItem)
    }
}

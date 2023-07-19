//
//  ChooseCategoryViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 20.04.2023.
//

import UIKit

protocol ChooseCategoryViewControllerDelegate: AnyObject {
    func createNewCategory(title: String)
}

final class ChooseCategoryViewController: UIViewController {
    
    private let addCategoryButton = UIButton()
    private let addCategoryLabel = UILabel()
    private let plugView = UIView()
    private let plugImageView = UIImageView()
    private let plugLabelView = UILabel()
    private let tableView = UITableView()
    private let newCategoryViewController = NewCategoryViewController()
    private let trackerCategoryStore = TrackerCategoryStore()
    private lazy var categories: [String] = {
        var stringCategories: [String] = []
        for category in trackerCategoryStore.categories {
            stringCategories.append(category.title)
        }
        return stringCategories
    }()
    private var selectedItem: Int?
    
    weak var delegate: NewTrackerViewControllerCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Interface
    
    private func setupUI() {
        title = "Категория"
        view.backgroundColor = .white
        configureAddButton()
        configurePlugView()
        configureTrackerCategoryTable()
        configureConstraints()
    }
    
    private func configureAddButton() {
        addCategoryButton.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        addCategoryLabel.text = "Добавить категорию"
        addCategoryLabel.textColor = .white
        addCategoryLabel.font = .systemFont(ofSize: 16, weight: .medium)
        addCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        addCategoryButton.addSubview(addCategoryLabel)
    }
    
    func configurePlugView() {
        plugView.backgroundColor = .white
        plugView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugView)
        
        plugImageView.image = UIImage(named: "categoryPlugImage")
        plugImageView.translatesAutoresizingMaskIntoConstraints = false
        plugView.addSubview(plugImageView)
        
        plugLabelView.text = """
        Привычки и события можно
        объединить по смыслу
        """
        plugLabelView.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabelView.translatesAutoresizingMaskIntoConstraints = false
        plugView.addSubview(plugLabelView)
    }
    
    private func configureTrackerCategoryTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            addCategoryLabel.centerXAnchor.constraint(equalTo: addCategoryButton.centerXAnchor),
            addCategoryLabel.centerYAnchor.constraint(equalTo: addCategoryButton.centerYAnchor),
            
            plugView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            plugView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plugView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plugView.topAnchor.constraint(equalTo: view.topAnchor),
            
            plugImageView.centerYAnchor.constraint(equalTo: plugView.centerYAnchor),
            plugImageView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor),
            
            plugLabelView.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabelView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -10)
        ])
    }

    
    @objc func addCategoryButtonTapped() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
}

extension ChooseCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let cell = cell,
              let text = cell.textLabel?.text
        else { return }
//        if categories.count == 1 {
//            cell.layer.cornerRadius = 16
//        } else {
//            cell.layer.cornerRadius = 0
//        }
        cell.accessoryType = .checkmark
        delegate?.didSelectCategory(category: categories[indexPath.row])
        dismiss(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

// MARK: - UITableViewDataSource

extension ChooseCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        if indexPath.row == selectedItem {
            cell.accessoryType = .checkmark
        }
        cell.backgroundColor = UIColor(red: 0.9, green: 0.91, blue: 0.92, alpha: 0.3)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension ChooseCategoryViewController: ChooseCategoryViewControllerDelegate {
    func createNewCategory(title: String) {
        categories.append(title)
        tableView.reloadData()
    }
}

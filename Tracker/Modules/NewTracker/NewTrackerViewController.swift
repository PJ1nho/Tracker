//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 17.04.2023.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func createNewTracker(name: String)
}

final class NewTrackerViewController: UIViewController {
    
    private let textFieldView = UIView()
    private let textField = UITextField()
    private let menuTableView = MenuTableView()
    private let stackView = UIStackView()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Interface
    
    private func setupUI() {
        title = "Новая привычка"
        view.backgroundColor = .white
        configuretextFieldView()
        configureTextField()
        configureMenuTableView()
        configureStackView()
        configureCancelButton()
        configureCreateButton()
        configureConstraints()
    }
    
    private func configuretextFieldView() {
        textFieldView.layer.cornerRadius = 16
        textFieldView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldView)
    }
    
    private func configureTextField() {
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
    }
    
    private func configureMenuTableView() {
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTableView)
        menuTableView.delegate = self
    }
    
    private func configureStackView() {
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderColor = CGColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

    }
    
    private func configureCreateButton() {
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            
            textFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor),
            
            menuTableView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 24),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            menuTableView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
//            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
//            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
//            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            createButton.widthAnchor.constraint(equalToConstant: 166),
//            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    // MARK: - Functions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        delegate?.createNewTracker(name: textField.text ?? "")
        self.dismiss(animated: true, completion: {
            self.presentingViewController?.dismiss(animated: true)
        })
    }
}

    // MARK: - MenuTableViewDelegate

extension NewTrackerViewController: MenuTableViewDelegate {
    func didTapMenu(menuItem: NewTrackerMenu) {
        switch menuItem {
        case .category:
            print("Hello")
        case .schedule:
            let newTrackerViewController = ScheduleViewController()
            let navigationController = UINavigationController(rootViewController: newTrackerViewController)
            present(navigationController, animated: true)
        }
    }
}

    // MARK: - UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

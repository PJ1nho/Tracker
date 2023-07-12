//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 30.06.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    private let textFieldView = UIView()
    private let textField = UITextField()
    private let readyButton = UIButton()
    
    weak var delegate: ChooseCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        title = "Новая категория"
        view.backgroundColor = .white
        configureTextFieldView()
        configureTextField()
        configureReadyButton()
        configureConstraints()
    }
    
    private func configureTextFieldView() {
        textFieldView.layer.cornerRadius = 16
        textFieldView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldView)
    }
    
    private func configureTextField() {
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(textField)
    }
    
    private func configureReadyButton() {
        readyButton.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        readyButton.layer.cornerRadius = 16
        readyButton.setTitleColor(.white, for: .normal)
        readyButton.setTitle("Готово", for: .normal)

        readyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readyButton)
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func readyButtonTapped() {
        delegate?.createNewCategory(title: textField.text ?? "")
        dismiss(animated: true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

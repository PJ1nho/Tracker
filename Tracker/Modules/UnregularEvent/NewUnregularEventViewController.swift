//
//  NewUnregularEventViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 03.07.2023.
//

import UIKit

protocol NewUnregularEventViewControllerDelegate: AnyObject {
    func createNewUnregularEvent(name: String, color: UIColor, emojie: String, category: String)
}

protocol NewUnregularEventViewControllerCategoryDelegate: AnyObject {
    func didSelectCategory(category: String)
}

final class NewUnregularEventViewController: UIViewController, NewTrackerViewControllerCategoryDelegate {
    
    private let contentView = UIView()
    private var scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let textFieldView = UIView()
    private let textField = UITextField()
    private let unregularMenuTableView = UnregularMenuTableView()
    private let emojiCollectionView = EmojiCollectionView()
    private let colorCollectionView = ColorCollectionView()
    private let buttonStackView = UIStackView()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    var selectedColor = UIColor.clear
    var selectedEmojie = String()
    var selectedCategory = String()
    
    weak var delegate: NewUnregularEventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
// MARK: - Interface
    
    private func setupUI() {
        title = "Новое нерегулярное событие"
        view.backgroundColor = .white
        configureContentView()
        configureScrollView()
        configureStackView()
        configureTextFieldView()
        configureTextField()
        configureMenuTableView()
        configureEmojiCollectionView()
        configureColorCollectionView()
        configureButtonStackView()
        configureCancelButton()
        configureCreateButton()
        configureConstraints()
    }
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
    }
    
    private func configureTextFieldView() {
        textFieldView.layer.cornerRadius = 16
        textFieldView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textFieldView)
    }
    
    private func configureTextField() {
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(textField)
    }
    
    private func configureMenuTableView() {
        unregularMenuTableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(unregularMenuTableView)
        unregularMenuTableView.delegate = self
    }
    
    private func configureEmojiCollectionView() {
        emojiCollectionView.delegate = self
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emojiCollectionView)
    }
    
    private func configureColorCollectionView(){
        colorCollectionView.delegate = self
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(colorCollectionView)
    }
    
    private func configureButtonStackView() {
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
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
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textFieldView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50),
            textFieldView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            
            unregularMenuTableView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 24),
            unregularMenuTableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            unregularMenuTableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            unregularMenuTableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojiCollectionView.topAnchor.constraint(equalTo: unregularMenuTableView.bottomAnchor, constant: -40),
            emojiCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 240),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 220),
            
            buttonStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -34),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            
        ])
        
    }
    
// MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        delegate?.createNewUnregularEvent(name: textField.text ?? "", color: selectedColor, emojie: selectedEmojie, category: selectedCategory)
        self.dismiss(animated: true, completion: {
            self.presentingViewController?.dismiss(animated: true)
        })
    }
}

// MARK: - UITextFieldDelegate

extension NewUnregularEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - ColorCollectionViewDelegate

extension NewUnregularEventViewController: ColorCollectionViewDelegate {
    func didSelectColor(color: UIColor) {
        selectedColor = color
    }
}

// MARK: - EmojiCollectionViewDelegate

extension NewUnregularEventViewController: EmojiCollectionViewDelegate {
    func didSelectEmojie(emojie: String) {
        selectedEmojie = emojie
    }
}

// MARK: - UnregularMenuTableViewDelegate

extension NewUnregularEventViewController: UnregularMenuTableViewDelegate {
    func didTapMenu(menuItem: NewUnregularMenu) {
        switch menuItem {
        case .category:
            let chooseCategoryViewController = ChooseCategoryViewController()
            chooseCategoryViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: chooseCategoryViewController)
            present(navigationController, animated: true)
        }
    }
}

extension NewUnregularEventViewController: NewUnregularEventViewControllerDelegate {
    func createNewUnregularEvent(name: String, color: UIColor, emojie: String, category: String) {
    }
}

extension NewUnregularEventViewController: NewUnregularEventViewControllerCategoryDelegate {
    func didSelectCategory(category: String) {
        selectedCategory = category
    }
}

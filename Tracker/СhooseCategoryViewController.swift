//
//  СhooseCategoryViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 20.04.2023.
//

import UIKit

final class СhooseCategoryViewController: UIViewController {
    
    private let addCategoryButton = UIButton()
    private let addCategoryLabel = UILabel()
    private let plugView = UIView()
    private let plugImageView = UIImageView()
    private let plugLabelView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //MARK: !!!!!!
        plugView.isHidden = true
    }
    
    private func setupUI() {
        title = "Категория"
        view.backgroundColor = .white
        configureAddButton()
        configurePlugView()
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
//        addTrackerEventButton.addTarget(self, action: #selector(addTrackerEventButtonTapped), for: .touchUpInside)
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
    
    private func configureCOnstraints() {
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
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
            plugLabelView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor)
        ])
    }
}

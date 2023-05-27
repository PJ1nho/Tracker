//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 10.04.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let plugView = UIView()
    private let plugImageView = UIImageView()
    private let plugLabelView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Interface
    
    func setupUI() {
        view.backgroundColor = .white
        configureTitleLabel()
        configurePlugView()
        configureConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Cтатистика"
        titleLabel.font = .boldSystemFont(ofSize: 34)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configurePlugView() {
        plugView.backgroundColor = .white
        plugView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugView)
        
        plugImageView.image = UIImage(named: "statisticPlugImage")
        plugImageView.translatesAutoresizingMaskIntoConstraints = false
        plugView.addSubview(plugImageView)
        
        plugLabelView.text = "Анализировать пока нечего"
        plugLabelView.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabelView.translatesAutoresizingMaskIntoConstraints = false
        plugView.addSubview(plugLabelView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            plugView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            plugView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plugView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plugView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            plugImageView.centerYAnchor.constraint(equalTo: plugView.centerYAnchor),
            plugImageView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor),
            
            plugLabelView.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabelView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor)
        ])
    }
}


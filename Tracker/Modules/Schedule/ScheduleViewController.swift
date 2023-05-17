//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 22.04.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    private let scheduleTableView = ScheduleTableView()
    private let readyButton = UIButton()
    private let readyButtonLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Расписание"
        view.backgroundColor = .white
        configureTableView()
        configureReadyButton()
        configureConstraints()
    }
    
    private func configureTableView() {
        view.addSubview(scheduleTableView)
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureReadyButton() {
        readyButton.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        readyButton.layer.cornerRadius = 16
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readyButton)
        readyButtonLabel.text = "Готово"
        readyButtonLabel.textColor = .white
        readyButtonLabel.font = .systemFont(ofSize: 16, weight: .medium)
        readyButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        readyButton.addSubview(readyButtonLabel)
    }
    
    @objc private func readyButtonTapped() {
        dismiss(animated: true)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.topAnchor.constraint(equalTo: scheduleTableView.bottomAnchor, constant: 47),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            
            readyButtonLabel.centerXAnchor.constraint(equalTo: readyButton.centerXAnchor),
            readyButtonLabel.centerYAnchor.constraint(equalTo: readyButton.centerYAnchor)
        ])
    }
    
}

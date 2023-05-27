//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 10.04.2023.
//

import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func createNewTracker(name: String)
}

final class AddTrackerViewController: UIViewController {
    
    private let addTrackerEventButton = UIButton()
    private let trackerEventButtonLabel = UILabel()
    private let addUnregularEventButton = UIButton()
    private let unregularEventButtonLabel = UILabel()
    
    weak var delegate: AddTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Interface
    
    func setupUI() {
        title = "Создание трекера"
        view.backgroundColor = .white
        configureTrackerEventButton()
        configureUnregularEventButton()
        confugureConstraints()
    }
    
    func configureTrackerEventButton() {
        addTrackerEventButton.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        addTrackerEventButton.layer.cornerRadius = 16
        addTrackerEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addTrackerEventButton)
        trackerEventButtonLabel.text = "Привычка"
        trackerEventButtonLabel.textColor = .white
        trackerEventButtonLabel.font = .systemFont(ofSize: 16, weight: .medium)
        trackerEventButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        addTrackerEventButton.addTarget(self, action: #selector(addTrackerEventButtonTapped), for: .touchUpInside)
        addTrackerEventButton.addSubview(trackerEventButtonLabel)
    }

    
    func configureUnregularEventButton() {
        addUnregularEventButton.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        addUnregularEventButton.layer.cornerRadius = 16
        addUnregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addUnregularEventButton)
        unregularEventButtonLabel.text = "Нерегулярное событие"
        unregularEventButtonLabel.textColor = .white
        unregularEventButtonLabel.font = .systemFont(ofSize: 16, weight: .medium)
        unregularEventButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        addUnregularEventButton.addSubview(unregularEventButtonLabel)
//        addUnregularEventButton.addTarget(self, action: #selector(unregularEventButtonTapped), for: .touchUpInside)
    }
    
//    @objc private func unregularEventButtonTapped() {
//       
//    }
    
    func confugureConstraints() {
        NSLayoutConstraint.activate([
            addTrackerEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTrackerEventButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addTrackerEventButton.widthAnchor.constraint(equalToConstant: 335),
            addTrackerEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            trackerEventButtonLabel.centerXAnchor.constraint(equalTo: addTrackerEventButton.centerXAnchor),
            trackerEventButtonLabel.centerYAnchor.constraint(equalTo: addTrackerEventButton.centerYAnchor),
            
            unregularEventButtonLabel.centerXAnchor.constraint(equalTo: addUnregularEventButton.centerXAnchor),
            unregularEventButtonLabel.centerYAnchor.constraint(equalTo: addUnregularEventButton.centerYAnchor),
            
            addUnregularEventButton.topAnchor.constraint(equalTo: addTrackerEventButton.bottomAnchor, constant: 16),
            addUnregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addUnregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            addUnregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: - Functions
    
    @objc private func addTrackerEventButtonTapped() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newTrackerViewController)
        present(navigationController, animated: true)
    }
}

    //MARK: - NewTrackerViewControllerDelegate

extension AddTrackerViewController: NewTrackerViewControllerDelegate {
    func createNewTracker(name: String) {
        delegate?.createNewTracker(name: name)
    }
}

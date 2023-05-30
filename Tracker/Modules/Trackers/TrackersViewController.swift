//
//  ViewController.swift
//  Tracker
//
//  Created by Тихтей  Павел on 04.04.2023.
//

import UIKit

class TrackersViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let searchTextField = UISearchTextField()
    private let plugView = UIView()
    private let plugImageView = UIImageView()
    private let plugLabelView = UILabel()
    private let trackerItemsView = TrackerItemsView()
    private var addTrackerButton = UIButton()
    private var categories: [TrackerCategory] = [
        .init(title: "Домашний уют", trackers: [.init(id: UUID(), name: "abc", color: .red, emojie: "😪", schedule: [.friday]), .init(id: UUID(), name: "ABC", color: .green, emojie: "😪", schedule: [.wednesday])]), .init(title: "Заголовок 2", trackers: [.init(id: UUID(), name: "123", color: .black, emojie: "😪", schedule: [.friday])])
    ]
    private var completedTrackers = [TrackerRecord]()
    private var completedSet = Set<UUID>()
    private var currentDate: Date!
    private var filterCategories = [TrackerCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCategories = categories
        setupUI()
    }
    
    // MARK: - Interface
    
    func setupUI() {
        view.backgroundColor = .white
        configurePlugView()
        currentDate = Date()
        configureAddTrackerButton()
        configureTitleLabel()
        configureDatePicker()
        configureSearchTextField()
        configureTracker()
        configureConstraints()
    }
    
    private func configurePlugView() {
        plugView.backgroundColor = .white
        plugView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugView)
        
        plugImageView.image = UIImage(named: "categoryPlugImage")
        plugImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugImageView)
        
        plugLabelView.text = "Что будем отслеживать?"
        plugLabelView.font = .systemFont(ofSize: 12, weight: .medium)
        plugLabelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plugLabelView)
        
        if categories.isEmpty {
            trackerItemsView.isHidden = true
            plugView.isHidden = false
        } else {
            trackerItemsView.isHidden = false
            plugView.isHidden = true
        }
    }
    
    func configureAddTrackerButton() {
        addTrackerButton = UIButton.systemButton(with: UIImage(named: "addTrackerButton")!, target: self, action: .none)
        addTrackerButton.tintColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
        view.addSubview(addTrackerButton)
    }

    func configureTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.font = .boldSystemFont(ofSize: 34)
        titleLabel.tintColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
    }
    
    func configureSearchTextField() {
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "Поиск"
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
    }
    
    func configureTracker() {
        trackerItemsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerItemsView)
        trackerItemsView.delegate = self
        trackerItemsView.configure(viewModel: .init(categories: categories, completedTrackers: completedTrackers, currentDate: currentDate))
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 19),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 91),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackerItemsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            trackerItemsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerItemsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerItemsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            plugView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugImageView.centerYAnchor.constraint(equalTo: plugView.centerYAnchor),
            plugImageView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor),
            
            plugLabelView.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabelView.centerXAnchor.constraint(equalTo: plugView.centerXAnchor)
        ])
        

    }
    
    // MARK: - Functions
    
    @objc private func addTrackerButtonTapped() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatterService.shared.datePickerFormatter
        let selectedDate: String = dateFormatter.string(from: sender.date)
        let date = dateFormatter.date(from: selectedDate)
        guard let date = date else { return }
        datePicker.date = date
        currentDate = date
        trackerItemsView.configure(viewModel: .init(categories: filterCategories, completedTrackers: completedTrackers, currentDate: currentDate))
        presentedViewController?.dismiss(animated: true)
    }
    
    func checkingPlugView() {
        if filterCategories.isEmpty {
            trackerItemsView.isHidden = true
            plugView.isHidden = false
        } else {
            trackerItemsView.isHidden = false
            plugView.isHidden = true
        }
    }
}

    //MARK: - TrackerItemsViewDelegate

extension TrackersViewController: TrackerItemsViewDelegate {
    func didTapDoneButton(trackerId: UUID) {
        let futureDate = Date()
        if futureDate < currentDate {
            return
        }
        if let trackerIndex = completedTrackers.firstIndex { $0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day)} {
            completedTrackers.remove(at: trackerIndex)
        } else {
            completedTrackers.append(.init(id: trackerId, date: currentDate))
            completedSet.insert(trackerId)
        }
        trackerItemsView.configure(viewModel: .init(categories: filterCategories, completedTrackers: completedTrackers, currentDate: currentDate))
    }
}

    //MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchString = ""
        if range.length > 0 {
            searchString = "\(textField.text!.dropLast())"
        } else {
            searchString = "\(textField.text! + string)"
        }
        filterCategories = categories.filter { $0.trackers.contains { $0.name.lowercased().hasPrefix(searchString.lowercased())  } }
        checkingPlugView()
        print(searchString)
        if searchString.isEmpty {
            filterCategories = categories
            trackerItemsView.configure(viewModel: .init(categories: categories, completedTrackers: completedTrackers, currentDate: currentDate))
        } else {
            trackerItemsView.configure(viewModel: .init(categories: filterCategories, completedTrackers: completedTrackers, currentDate: currentDate))
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        filterCategories = categories
        checkingPlugView()
        trackerItemsView.configure(viewModel: .init(categories: categories, completedTrackers: completedTrackers, currentDate: currentDate))
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

    //MARK: - AddTrackerViewControllerDelegate

extension TrackersViewController: AddTrackerViewControllerDelegate {
    func createNewTracker(name: String) {
        if categories.contains(where: { $0.title == "Тест 1"}),
           let index = categories.firstIndex(where: { $0.title == "Тест 1"}) {
            categories[index].trackers.append(.init(id: UUID(), name: name, color: .cyan, emojie: "😪", schedule: [.monday]))
        } else {
            categories.append(.init(title: "Тест 1", trackers: [.init(id: UUID(), name: name, color: .cyan, emojie: "😪", schedule: [.monday])]))
        }
        filterCategories = categories
        trackerItemsView.configure(viewModel: .init(categories: categories, completedTrackers: completedTrackers, currentDate: currentDate))
    }
}

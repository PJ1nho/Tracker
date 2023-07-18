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
    private lazy var categories = categoryStore.categories
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date!
    private var filterCategories = [TrackerCategory]()
    private lazy var trackerStore: TrackerStoreProtocol = TrackerStore(delegate: self)
    private lazy var trackerRecordStore = TrackerRecordStore()
    private let categoryStore = TrackerCategoryStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCategories = categories
        setupUI()
    }
    
    // MARK: - Interface
    
    func setupUI() {
        view.backgroundColor = .white
        configurePlugView()
        currentDate = DateFormatterService.shared.getFormatterDate(date: Date())
        configureAddTrackerButton()
        configureTitleLabel()
        configureDatePicker()
        configureSearchTextField()
        configureTracker()
        configureConstraints()
        trackerItemsView.trackerStore = trackerStore
        trackerRecordStore.delegate = self
        try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchTextField.text ?? "")
        try? trackerRecordStore.getCompletedTrackers()
        trackerItemsView.updateCollectionView()
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
        
        checkingPlugView(searchText: searchTextField.text)
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
//        trackerItemsView.configure(viewModel: .init(categories: categories, completedTrackers: completedTrackers, currentDate: currentDate))
        trackerItemsView.updateRecords(records: completedTrackers)
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
        currentDate = DateFormatterService.shared.getFormatterDate(date: date)
//        trackerItemsView.configure(viewModel: .init(categories: filterCategories, completedTrackers: completedTrackers, currentDate: currentDate))
        try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchTextField.text ?? "")
        trackerItemsView.configure(viewModel: .init(currentDate: currentDate))
        trackerItemsView.updateCollectionView()
        presentedViewController?.dismiss(animated: true)
    }
    
    func checkingPlugView(searchText: String?) {
        if let searchText = searchText,
           trackerStore.numberOfSections < 1 && searchText.isEmpty {
            trackerItemsView.isHidden = true
            plugView.isHidden = false
            plugImageView.isHidden = false
            plugLabelView.isHidden = false
            plugLabelView.text = "Что будем отслеживать?"
        } else if let searchText = searchText,
                  trackerStore.numberOfSections < 1 && !searchText.isEmpty {
            trackerItemsView.isHidden = true
            plugView.isHidden = false
            plugImageView.isHidden = false
            plugLabelView.isHidden = false
            plugLabelView.text = "Ничего не найдено"
        }
        else {
            trackerItemsView.isHidden = false
            plugView.isHidden = true
            plugImageView.isHidden = true
            plugLabelView.isHidden = true
        }
    }
}

    //MARK: - TrackerItemsViewDelegate

extension TrackersViewController: TrackerItemsViewDelegate {
    func didTapDoneButton(trackerId: UUID) {
        let futureDate = DateFormatterService.shared.getFormatterDate(date: Date())
        currentDate = DateFormatterService.shared.getFormatterDate(date: currentDate)
        if futureDate < currentDate {
            return
        }
        if let trackerRecord = completedTrackers.first { $0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day)} {
//            completedTrackers.remove(trackerRecord)
            try? trackerRecordStore.remove(record: trackerRecord)
        } else {
            try? trackerRecordStore.add(record: .init(id: trackerId, date: currentDate))
//            completedTrackers.insert(.init(id: trackerId, date: currentDate))
        }
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

        try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchString)
        trackerItemsView.updateCollectionView()
        checkingPlugView(searchText: searchString)

        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: "")
        trackerItemsView.updateCollectionView()
        checkingPlugView(searchText: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - AddTrackerViewControllerDelegate

extension TrackersViewController: AddTrackerViewControllerDelegate {
    func createNewTracker(name: String, color: UIColor, emojie: String, schedule: [Schedule]?, category: String) {
        let tracker = Tracker(id: UUID(), name: name, color: color, emojie: emojie, schedule: schedule)
//        if categories.contains(where: { $0.title == category}),
//           let index = categories.firstIndex(where: { $0.title == category }) {
//            categories[index].trackers.append(tracker)
//            // comm ОБНОВЛЯТТЬ ДАННЫЕ В КОРДАТЕ
//        } else {
//            // comm CОЗДАВАТЬ В КОРДАТЕ
//            categories.append(.init(id: UUID(), title: category, trackers: [tracker]))
////            categoryStore.
//        }
//        filterCategories = categories
////        trackerItemsView.configure(viewModel: .init(categories: categories, completedTrackers: completedTrackers, currentDate: currentDate))
        DispatchQueue.main.async {
            do {
                let categoryTracker = self.categories.first { $0.title == category }
                guard let unwrapCategory = categoryTracker else { return }
                try self.trackerStore.saveTracker(tracker: tracker, in: unwrapCategory)
            } catch let error {
                print("Tracker save error \(error.localizedDescription)")
            }
        }
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func didUpdateTracker(_ insertedSections: IndexSet, _ deletedSections: IndexSet, _ updatedIndexPaths: [IndexPath], _ insertedIndexPaths: [IndexPath], _ deletedIndexPaths: [IndexPath]) {
//        DispatchQueue.main.async {
//            self.trackerItemsView.collectionView.performBatchUpdates {
//                self.trackerItemsView.collectionView.insertSections(insertedSections)
//                self.trackerItemsView.collectionView.deleteSections(deletedSections)
//                self.trackerItemsView.collectionView.reloadItems(at: updatedIndexPaths)
//                self.trackerItemsView.collectionView.insertItems(at: insertedIndexPaths)
//                self.trackerItemsView.collectionView.deleteItems(at: deletedIndexPaths)
//            }
//        }
    }

    func updateTrackersCollection() {
        trackerItemsView.updateCollectionView()
        configurePlugView()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdate(records: Set<TrackerRecord>) {
        completedTrackers = records
        trackerItemsView.updateRecords(records: records)
        configurePlugView()
    }
}

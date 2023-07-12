//
//  TrackerItemsView.swift
//  Tracker
//
//  Created by Тихтей  Павел on 16.04.2023.
//

import UIKit

protocol TrackerItemsViewDelegate: AnyObject {
    func didTapDoneButton(trackerId: UUID)
//    func updateCategories()
}

class TrackerItemsView: UIView {
    
    var collectionView: UICollectionView!
    var trackerStore: TrackerStoreProtocol!
    private var trackerCategoryStore = TrackerCategoryStore()
    private lazy var categories = trackerCategoryStore.categories
    private var completedTrackers = [TrackerRecord]()
    private var currentDate = Date()
    
    weak var delegate: TrackerItemsViewDelegate?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Interface
    
    func setupUI() {
        configureCollectionView()
        addSubview(collectionView)
        configureConstraints()
        collectionView.reloadData()
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(TrackerCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    //MARK: - Functions
    
    func configure(viewModel: ViewModel) {
        self.categories = viewModel.categories
        self.completedTrackers = viewModel.completedTrackers
        self.currentDate = viewModel.currentDate
        collectionView.reloadData()
    }
}

    //MARK: - UICollectionViewDataSource&UICollectionViewDelegate

extension TrackerItemsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerStore.numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerStore.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell
        cell?.delegate = self
        guard let tracker = trackerStore.object(at: indexPath) else { return cell! }
        let days = completedTrackers.filter { $0.id == tracker.id }.count
        let dateFormatter = DateFormatterService.shared.dateFormatterCell
        let isSelected = completedTrackers.contains { trackerRecord in
            let trackerRecordDateString = dateFormatter.string(from: trackerRecord.date)
            let sameDay = Calendar.current.isDate(trackerRecord.date, equalTo: currentDate, toGranularity: .day)
            guard trackerRecord.id == tracker.id,
                  sameDay else { return false }
            return true
        }
        cell?.configure(tracker: tracker, days: days, isSelected: isSelected)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerCellHeader
        let item = categories[indexPath.section]
        view?.titleLabel.text = item.title
        return view ?? UICollectionReusableView()
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout

extension TrackerItemsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 42) / 2
        return CGSize(width: itemWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 5, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

    //MARK: - TrackerCellDelegate

extension TrackerItemsView: TrackerCellDelegate {
    func didTapDoneButton(trackerId: UUID) {
        delegate?.didTapDoneButton(trackerId: trackerId)
    }
}

extension TrackerItemsView {
    struct ViewModel {
        let categories: [TrackerCategory]
        let completedTrackers: [TrackerRecord]
        let currentDate: Date
    }
}

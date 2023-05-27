//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Тихтей  Павел on 18.04.2023.
//

import UIKit

final class ColorCollectionView: UIView {
    private var collectionView: UICollectionView!
    private let colorsArray = [
        UIColor(red: 0.992, green: 0.298, blue: 0.286, alpha: 1),
        UIColor(red: 1, green: 0.533, blue: 0.118, alpha: 1),
        UIColor(red: 0, green: 0.482, blue: 0.98, alpha: 1),
        UIColor(red: 0.431, green: 0.267, blue: 0.996, alpha: 1),
        UIColor(red: 0.2, green: 0.812, blue: 0.412, alpha: 1),
        UIColor(red: 0.902, green: 0.427, blue: 0.831, alpha: 1),
        UIColor(red: 0.976, green: 0.831, blue: 0.831, alpha: 1),
        UIColor(red: 0.204, green: 0.655, blue: 0.996, alpha: 1),
        UIColor(red: 0.275, green: 0.902, blue: 0.616, alpha: 1),
        UIColor(red: 0.208, green: 0.204, blue: 0.486, alpha: 1),
        UIColor(red: 1, green: 0.404, blue: 0.302, alpha: 1),
        UIColor(red: 1, green: 0.6, blue: 0.8, alpha: 1),
        UIColor(red: 0.965, green: 0.769, blue: 0.545, alpha: 1),
        UIColor(red: 0.475, green: 0.58, blue: 0.961, alpha: 1),
        UIColor(red: 0.514, green: 0.173, blue: 0.945, alpha: 1),
        UIColor(red: 0.678, green: 0.337, blue: 0.855, alpha: 1),
        UIColor(red: 0.553, green: 0.447, blue: 0.902, alpha: 1),
        UIColor(red: 0.184, green: 0.816, blue: 0.345, alpha: 1)
    ]
    
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
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isScrollEnabled = false 
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
}

    //MARK: UICollectionViewDataSource&UICollectionViewDelegate

extension ColorCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColorCell
        cell?.contentView.backgroundColor = colorsArray[indexPath.row]
        cell?.contentView.layer.cornerRadius = 8
        return cell!
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 17
//    }
}

    //MARK: UICollectionViewDelegateFlowLayout

extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 135) / 6
        return CGSize(width: itemWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25)
    }
}

//
//  ColorCell.swift
//  Tracker
//
//  Created by Тихтей  Павел on 18.04.2023.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        configureColorView()
        configureConstraints()
    }
    
    func configureColorView() {
        colorView.backgroundColor = .clear
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

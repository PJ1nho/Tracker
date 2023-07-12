//
//  EmojiCell.swift
//  Tracker
//
//  Created by Тихтей  Павел on 17.04.2023.
//

import UIKit 

final class EmojiCell: UICollectionViewCell {

    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    
    func setupCellUI() {
        contentView.layer.cornerRadius = 16
        configureTitleLabel()
        configureConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = ""
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

//
//  TrackerCell.swift
//  Tracker
//
//  Created by Тихтей  Павел on 10.04.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapDoneButton(trackerId: UUID)
}

final class TrackerCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let daysCountLabel = UILabel()
    private let emojiShadowView = UIView()
    private let emojiLabel = UILabel()
    private let completionButton = UIButton()
    private let colorView = UIView()
    private var tracker: Tracker!
    
    weak var delegate: TrackerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        configureColorView()
        configureTitleLabel()
        configureEmojieShadow()
        configureEmojiLabel()
        configureCompletionButton()
        configureDaysCountLabel()
        configureConstraints()
    }
    
    func configureColorView() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = UIColor(red: 0.2, green: 0.812, blue: 0.412, alpha: 1)
        colorView.layer.cornerRadius = 16
        contentView.addSubview(colorView)
    }
    
    func configureTitleLabel() {
        colorView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Поливать растения"
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
    }
    
    func configureEmojieShadow() {
        colorView.addSubview(emojiShadowView)
        emojiShadowView.translatesAutoresizingMaskIntoConstraints = false
        emojiShadowView.layer.cornerRadius = 12
        emojiShadowView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    }
    
    func configureEmojiLabel() {
        emojiShadowView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = "❤️"
        emojiLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    func configureCompletionButton() {
        contentView.addSubview(completionButton)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        completionButton.setImage(UIImage(named: "plusWhite"), for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.layer.cornerRadius = 17
        completionButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    func configureDaysCountLabel() {
        contentView.addSubview(daysCountLabel)
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        daysCountLabel.text = "1 день"
        daysCountLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysCountLabel.textColor = .black
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
            
            emojiShadowView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiShadowView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiShadowView.widthAnchor.constraint(equalToConstant: 24),
            emojiShadowView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiShadowView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiShadowView.centerXAnchor),

            
            completionButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            completionButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34),
            
            daysCountLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    func configure(tracker: Tracker, days: Int, isSelected: Bool) {
        self.tracker = tracker
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emojie
        colorView.backgroundColor = tracker.color
        completionButton.backgroundColor = tracker.color
        daysCountLabel.text = "\(days) дней"
        if isSelected {
            completionButton.setImage(UIImage(named: "doneImage"), for: .normal)
            completionButton.alpha = 0.3
        } else {
            completionButton.setImage(UIImage(named: "plusWhite"), for: .normal)
            completionButton.alpha = 1
        }
    }
    
    @objc func didTapDoneButton() {
        delegate?.didTapDoneButton(trackerId: tracker.id)
    }
}


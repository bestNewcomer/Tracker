//
//  CollectionCell.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 03.02.2024.
//

import Foundation
import UIKit

final class TrackerCollectionCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let cellID = "TrackersCell"
    
    // MARK: - Private Properties
    private var index = 0
    private var previousImage = UIImage(named: "imageCheckMark")!
    private let buttonImage = UIImage(named: "addSkillButton")!
    
    private var colorTopCell: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSelection18
        view.layer.cornerRadius = 16
        return view
        
    }()
    
    private var smileyLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "❤️"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .ypTransparentWhite
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Поливать растения"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhiteDay
        return label
    }()
    
    private var counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "0 день"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var countButtom: UIButton = {
        let button = UIButton.systemButton(
            with: buttonImage,
            target: TrackerCollectionCell?.self,
            action: #selector(Self.pressCounterButton))
        button.layer.cornerRadius = 16
        button.backgroundColor = .colorSelection18
        button.tintColor = .ypWhiteDay
        return button
    }()
    
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        cellElementSettings()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc
    private func pressCounterButton () {
        if counterLabel.text == "0 день" {
            countButtom.setImage(previousImage, for: .normal)
            counterLabel.text = "1 день"
        }else if counterLabel.text == "1 день" {
            countButtom.setImage(buttonImage, for: .normal)
            counterLabel.text = "0 день"
        }
    }
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func addSubView(){
        contentView.addSubview(colorTopCell)
        colorTopCell.addSubview(smileyLabel)
        colorTopCell.addSubview(titleLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(countButtom)
        
    }
    
    private func cellElementSettings(){
        colorTopCell.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        smileyLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        countButtom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorTopCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorTopCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorTopCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorTopCell.heightAnchor.constraint(equalToConstant: 90),
            
            smileyLabel.leadingAnchor.constraint(equalTo: colorTopCell.leadingAnchor, constant:  12),
            smileyLabel.topAnchor.constraint(equalTo: colorTopCell.topAnchor, constant:  12),
            smileyLabel.widthAnchor.constraint(equalToConstant: 24),
            smileyLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: smileyLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: colorTopCell.trailingAnchor, constant:  -12),
            titleLabel.bottomAnchor.constraint(equalTo: colorTopCell.bottomAnchor, constant:  -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            
            counterLabel.leadingAnchor.constraint(equalTo: smileyLabel.leadingAnchor),
            counterLabel.topAnchor.constraint(equalTo: colorTopCell.bottomAnchor, constant:  16),
            counterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -27),
            counterLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countButtom.topAnchor.constraint(equalTo: colorTopCell.bottomAnchor, constant:  8),
            countButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -12),
            countButtom.heightAnchor.constraint(equalToConstant: 34),
            countButtom.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
}

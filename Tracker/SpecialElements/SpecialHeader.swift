//
//  SpecialHeader.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 16.02.2024.
//

import UIKit

final class SpecialHeader: UILabel {
    // MARK: - Public Properties
    var labelSpecial: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settingsHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func customizeHeader(nameHeader: String) {
        labelSpecial.text = nameHeader
    }
    
    // MARK: - Private Methods
    private func settingsHeader() {
        addSubview(labelSpecial)
        
        labelSpecial.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            labelSpecial.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            labelSpecial.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelSpecial.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}

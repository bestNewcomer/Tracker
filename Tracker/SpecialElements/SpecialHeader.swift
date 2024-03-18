//
//  SpecialHeader.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 16.02.2024.
//

import UIKit

final class SpecialHeader: UILabel {
    // MARK: - Public Properties
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay
        return view
    }()
    
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
        addSubview(backgroundView)
        backgroundView.addSubview(labelSpecial)
        
        labelSpecial.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 61),
            
            labelSpecial.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 27),
            labelSpecial.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
        ])
    }
}

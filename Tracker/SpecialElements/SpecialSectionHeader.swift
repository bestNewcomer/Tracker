//
//  TrackerSupplementaryView.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 04.02.2024.
//

import Foundation
import UIKit

final class SpecialSectionHeader: UICollectionReusableView {
    // MARK: - Public Properties
    static let headerID = "TrackersHeader"
    let titleLabel = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.text = "Домашний уют"
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

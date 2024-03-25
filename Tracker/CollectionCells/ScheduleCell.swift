//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 11.03.2024.
//

import Foundation
import UIKit

final class ScheduleCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let cellID = "ScheduleCell"
    
    let daySwitch = DaySwitch()
    var onSwitchChanged: ((Bool) -> Void)?
    var selectSwitch = 0
    
    lazy var labelBasic: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        return view
    }()
    
    lazy var switchDay: DaySwitch = {
        let switchDay = DaySwitch()
        switchDay.addTarget(self, action: #selector(self.didTapSwitch), for: .valueChanged)
        switchDay.onTintColor = UIColor(named: "ypBlue")
        return switchDay
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func didTapSwitch(_ sender: DaySwitch){
        onSwitchChanged?(sender.isOn)
    }
    
    // MARK: - Public Methods
    func renamingLabelBasic(nameView: String, isOn: Bool) {
        labelBasic.text = nameView
        switchDay.isOn = isOn
    }
    
    // MARK: - Private Methods
    private func settingsView() {
        contentView.addSubview(divider)
        contentView.addSubview(labelBasic)
        contentView.addSubview(switchDay)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        labelBasic.translatesAutoresizingMaskIntoConstraints = false
        switchDay.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .backgroundDay
        contentView.isOpaque = true
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            divider.centerXAnchor.constraint(equalTo: centerXAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            labelBasic.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelBasic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelBasic.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            switchDay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchDay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -24),
        ])
    }
}

//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 11.03.2024.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func didTapSwitch(days: DaysOfWeek, active: Bool)
}

final class ScheduleCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let cellID = "ScheduleCell"
    weak var delegate: ScheduleCellDelegate?
    
    // MARK: - Private Properties
    private var days: DaysOfWeek?
    
    private lazy var labelBasic: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var switchDay: UISwitch = {
        let switchDay = UISwitch()
        switchDay.addTarget(self, action: #selector(self.didTapSwitch), for: .valueChanged)
        switchDay.onTintColor = UIColor(named: "ypBlue")
        return switchDay
    }()
    
    // MARK: - Initializers
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        settingsView()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func didTapSwitch(_ sender: UISwitch){
        guard let days = days else { return }
        delegate?.didTapSwitch(days: days, active: sender.isOn)
    }
    
    // MARK: - Public Methods
    func config(with days: DaysOfWeek, nameView: String, isOn: Bool) {
        self.days = days
        labelBasic.text = nameView
        switchDay.isOn = isOn
    }
    
    // MARK: - Private Methods
    private func settingsView() {
        contentView.addSubview(labelBasic)
        contentView.addSubview(switchDay)
        
        labelBasic.translatesAutoresizingMaskIntoConstraints = false
        switchDay.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .backgroundDay
        
        NSLayoutConstraint.activate([
            labelBasic.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelBasic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelBasic.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            switchDay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchDay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -24),
        ])
    }
}

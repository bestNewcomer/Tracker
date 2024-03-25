//
//  CreatingTracker.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 10.02.2024.
//

import UIKit

final class ChoiceTrackerViewController: UIViewController {
    
    //MARK:  - Public Properties
    weak var delegate: NewTrackerCreationDelegate?
    var onTrackerCreated: (() -> Void)?
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        settingsView()
    }
    
    // MARK: - Actions
    @objc
    private func tapCreatingButton(){
        let createTracker = CreatingTrackerViewController()
        createTracker.delegate = delegate
        createTracker.modalPresentationStyle = .pageSheet
        createTracker.onCompletion = { [weak self] in
            self?.dismiss(animated: false, completion: self?.onTrackerCreated)
        }
        createTracker.habitIndicator = true
        present(createTracker, animated: true)
    }
    
    @objc
    private func tapIrregularButton(){
        let createTracker = CreatingTrackerViewController()
        createTracker.delegate = delegate
        createTracker.modalPresentationStyle = .pageSheet
        createTracker.onCompletion = { [weak self] in
            self?.dismiss(animated: false, completion: self?.onTrackerCreated)
        }
        createTracker.habitIndicator = false
        present(createTracker, animated: true)
    }
    
    //MARK:  - Private Methods
    private func settingsView () {
        let headerLabel: SpecialHeader = {
            let label = SpecialHeader()
            label.customizeHeader(nameHeader: "choiceTracker_title".localized)
            return label
        }()
        
        let habitButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 16
            button.backgroundColor = .ypBlackDay
            button.setTitle("choiceTracker_habit_button".localized, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .ypWhiteDay
            button.addTarget(self, action: #selector(Self.tapCreatingButton), for: .touchUpInside)
            return button
        }()
        
        let irregularButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 16
            button.backgroundColor = .ypBlackDay
            button.setTitle("choiceTracker_irregular_button".localized, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .ypWhiteDay
            button.addTarget(self, action: #selector(Self.tapIrregularButton), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(headerLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularButton)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 344),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            irregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

//
//  CreatingTracker.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 10.02.2024.
//

import UIKit

final class ChoiceTrackerViewController: UIViewController {
    
    //MARK:  - Private Properties
   
    // MARK: - Initializers

    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        settingsView()
    }
    
    // MARK: - Actions
    @objc
    private func tabCreatingButton(){
        let jump = CreatingTrackerViewController()
        jump.modalPresentationStyle = .pageSheet
        present(jump, animated: true)
    }
    
    @objc
    private func tabIrregularButton(){
        print("Переход на экран создания нерегулярного событие")
    }
    //MARK:  - Private Methods
    private func settingsView () {
        let headerLabel: UILabel = {
            let label = UILabel()
            label.text = "Создание трекера"
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textColor = .ypBlackDay
            return label
        }()

        let habitButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 16
            button.backgroundColor = .ypBlackDay
            button.setTitle("Привычка", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .ypWhiteDay
            button.addTarget(self, action: #selector(Self.tabCreatingButton), for: .touchUpInside)
            return button
        }()
        
        let irregularButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 16
            button.backgroundColor = .ypBlackDay
            button.setTitle("Нерегулярное событие", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .ypWhiteDay
            button.addTarget(self, action: #selector(Self.tabIrregularButton), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(headerLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularButton)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
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

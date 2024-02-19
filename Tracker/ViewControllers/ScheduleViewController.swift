//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 14.02.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
    
    //let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    //MARK:  - Private Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private let labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Расписание")
        return label
    }()
    
    private let readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(Self.tabReadyButton), for: .touchUpInside)
        return button
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        settingsConstraints()
        createStackView()
    }
    
    // MARK: - Actions
    @objc
    private func tabReadyButton(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:  - Private Methods
    
    private func createStackView() {
        var x = 0
        lazy var stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            stackView.backgroundColor = .backgroundDay
            stackView.layer.cornerRadius = 16
            return stackView
        }()
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for day in daysOfWeek{
            let specialView = SpecialView()
            specialView.customizeView(nameView: "\(day)", surnameView: nil)
            specialView.selectSwitch = 1
            stackView.addArrangedSubview(specialView.view)
            x = x + 1
            if x <= 6 {
                let divider = Divider()
                stackView.addArrangedSubview(divider)
            }
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labeltitle.bottomAnchor, constant: 35),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 525),
        ])
    }
    
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(readyButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            readyButton.topAnchor.constraint(equalTo: labeltitle.bottomAnchor, constant: 607),
            readyButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            readyButton.widthAnchor.constraint(equalToConstant: 335),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

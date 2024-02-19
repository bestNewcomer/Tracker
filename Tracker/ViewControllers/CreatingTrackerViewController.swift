//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 10.02.2024.
//

import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    //MARK:  - Private Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private let labelTitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Новая привычка")
        return label
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .backgroundDay
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.resignFirstResponder()
        return textField
    }()
    
    private let labelRestrictions: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .ypRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .backgroundDay
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    private lazy var ViewCategories: SpecialView = {
        let specialView = SpecialView()
        specialView.customizeView(nameView: "Категория", surnameView: nil) // добавить вместо nil входные данные
        return specialView
    }()
    
    private lazy var ViewSchedule: SpecialView = {
        let specialView = SpecialView()
        specialView.customizeView(nameView: "Расписание", surnameView: nil) // добавить вместо nil входные данные
        specialView.conditionTap()
        specialView.jump = ScheduleViewController()
       
        return specialView
    }()
    
    private lazy var divider: Divider = {
        let view = Divider()
        return view
    }()
    
    private lazy var lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(Self.tapСancelButton), for: .touchUpInside)
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        button.addTarget(self, action: #selector(Self.tabСreateButton), for: .touchUpInside)
        return button
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        settingsConstraints()
    }
    
    // MARK: - Actions
    @objc
    private func tapСancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func tabСreateButton(){
        print("Кнопка создания работает")
    }
   
    //MARK:  - Private Methods
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labelTitle)
        scrollView.addSubview(textField)
        scrollView.addSubview(stackView)
        scrollView.addSubview(lowerStackView)
        stackView.addArrangedSubview(ViewCategories.view)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(ViewSchedule.view)
        lowerStackView.addArrangedSubview(cancelButton)
        lowerStackView.addArrangedSubview(createButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labelTitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTitle.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 43),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textField.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            
            lowerStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 348),
            lowerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lowerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            lowerStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func settingsRestrictions() {
        
        scrollView.addSubview(labelRestrictions)
        
        labelRestrictions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelRestrictions.topAnchor.constraint(equalTo: textField.topAnchor, constant: 83),
            labelRestrictions.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            labelRestrictions.heightAnchor.constraint(equalToConstant: 22),
            
            stackView.topAnchor.constraint(equalTo: labelRestrictions.bottomAnchor, constant: 24),
        ])
    }
    
}

// MARK: - UITextFieldDelegate
extension CreatingTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            let currentLength = textField.text?.count ?? 0
            if currentLength + string.count > 38 {
                //settingsRestrictions() поправить констрейнты и включить уведомление о превышении 38 символов
                return false
            }
        }
        return true
    }
}

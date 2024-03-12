//
//  NewCategory.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.03.2024.
//

import Foundation
import UIKit

final class NewCategory: UIViewController {
    
    // MARK: - Public Properties
    
    //MARK:  - Private Properties
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Новая категория")
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
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
       
        settingsConstraints()
    }
    
    // MARK: - Actions
    @objc private func addCategory(){
        
    }
    
    //MARK:  - Private Methods
    private func settingsConstraints() {
        view.addSubview(labeltitle)
        view.addSubview(textField)
        view.addSubview(readyButton)
     
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labeltitle.topAnchor.constraint(equalTo: view.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            readyButton.topAnchor.constraint(equalTo: labeltitle.bottomAnchor, constant: 651),
            readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readyButton.widthAnchor.constraint(equalToConstant: 335),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func settingsRestrictions() {
        view.addSubview(labelRestrictions)
        
        labelRestrictions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelRestrictions.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            labelRestrictions.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelRestrictions.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}

// MARK: - UITextFieldDelegate
extension NewCategory: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            let currentLength = textField.text?.count ?? 0
            if currentLength + string.count > 38 {
                settingsRestrictions()
                return false
            } else {
                labelRestrictions.removeFromSuperview()
            }
        }
        return true
    }
}

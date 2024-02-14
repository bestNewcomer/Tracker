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
    
    private lazy var labeltitle: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
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
        return textField
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
        specialView.customizeView(nameView: "Категория", surnameView: "Жопа") // добавить вместо nil входные данные
        return specialView
    }()
    
    private lazy var ViewSchedule: SpecialView = {
        let specialView = SpecialView()
        specialView.customizeView(nameView: "Расписание", surnameView: "Пися") // добавить вместо nil входные данные
        return specialView
    }()
    
    private lazy var divider: Divider = {
        let view = Divider()
        return view
    }()

//    private let buttonCategories: UIButton = {
//        let button = UIButton()
//        button.setTitle("Категория", for: .normal)
//        button.setTitleColor(.ypBlackDay, for: .normal)
//        button.titleLabel?.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        button.backgroundColor = .red
//        button.setImage(UIImage(named: "imageArrow"), for: .normal)
//        button.imageView?.contentMode = .right
//        button.addTarget(CreatingTrackerViewController.self, action: #selector(Self.tabCategoriesButton), for: .touchUpInside)
//        return button
//    }()
    
   
    
    
    // MARK: - Initializers
    //    init() {
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        settingsConstraints()
    }
    
    // MARK: - Actions
    @objc
    private func tabCategoriesButton(){
      print("Зашибись")
        
    }
    
    //MARK:  - Private Methods
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(textField)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(ViewCategories)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(ViewSchedule)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: labeltitle.bottomAnchor, constant: 43),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textField.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
}


// MARK: - UITextFieldDelegate
extension CreatingTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            let currentLength = textField.text?.count ?? 0
            if currentLength + string.count > 38 {
                return false
            }
        }
        return true
    }
}

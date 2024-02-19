//
//  SpecialView.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.02.2024.
//

import UIKit

final class SpecialView: UIViewController {
    // MARK: - Public Properties
    var labelSecondary: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    var selectSwitch = 0
    var jump = UIViewController()
    
    // MARK: - Private Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var labelBasic: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var imageArrow: UIImageView = {
        let imVi = UIImageView(image: UIImage(named: "imageArrow"))
        imVi.contentMode = .scaleAspectFit
        return imVi
    }()
    
    private lazy var swithDay: UISwitch = {
        let swith = UISwitch()
        return swith
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView()
    }
    
    // MARK: - Actions
    func didTap(transitionAddress: UIViewController){
        jump = transitionAddress
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: view.self, action: #selector(didTapView)))
    }
    @objc func didTapView(){
        jump.modalPresentationStyle = .pageSheet
        present(jump, animated: true)
    }
    
    // MARK: - Public Methods
    
    func customizeView(nameView: String, surnameView: String? ) {
        labelBasic.text = nameView
        labelSecondary.text = surnameView
    }
    
    // MARK: - Private Methods
    private func settingsView() {
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if selectSwitch == 1 {
            
            view.addSubview(swithDay)
            
            swithDay.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                swithDay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                swithDay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -24),
            ])
        } else {
            view.addSubview(imageArrow)
            
            imageArrow.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageArrow.topAnchor.constraint(equalTo: view.topAnchor),
                imageArrow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -24),
                imageArrow.heightAnchor.constraint(equalTo: view.heightAnchor),
            ])
        }
        
        
        stackView.addArrangedSubview(labelBasic)
        if labelSecondary.text != nil {
            stackView.addArrangedSubview(labelSecondary)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                stackView.heightAnchor.constraint(equalTo: view.heightAnchor),
            ])
        }
    }
}


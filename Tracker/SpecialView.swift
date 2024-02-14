//
//  SpecialView.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.02.2024.
//

import UIKit

class SpecialView: UIView {
    // MARK: - Public Properties
    var labelSecondary: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
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
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    // MARK: - Public Methods
    func customizeView(nameView: String, surnameView: String? ) {
        labelBasic.text = nameView
        labelSecondary.text = surnameView
    }
    // MARK: - Private Methods
    private func settingsView() {
        addSubview(stackView)
        addSubview(imageArrow)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageArrow.topAnchor.constraint(equalTo: topAnchor),
            imageArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -24),
            imageArrow.heightAnchor.constraint(equalTo: heightAnchor),
        ])
        
        stackView.addArrangedSubview(labelBasic)
        if labelSecondary.text != nil {
            stackView.addArrangedSubview(labelSecondary)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                stackView.heightAnchor.constraint(equalTo: heightAnchor),
            ])
        }
    }
}

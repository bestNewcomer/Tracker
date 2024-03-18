//
//  SpecialView.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.02.2024.
//

import UIKit

final class SpecialView: UIViewController {
    
    // MARK: - Public Properties
    lazy var labelBasic: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    lazy var labelSecondary: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    var jump: (() -> Void)?
    
    // MARK: - Private Properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    private lazy var imageArrow: UIImageView = {
        let imVi = UIImageView(image: UIImage(named: "imageArrow"))
        imVi.contentMode = .scaleAspectFit
        return imVi
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView()
    }
    
    // MARK: - Actions
    @objc func didTapView(_ sender: UITapGestureRecognizer){
        jump?()
    }
    
    
    // MARK: - Public Methods
    func renamingLabelBasic(nameView: String) {
        labelBasic.text = nameView
    }
    
    func renamingLabelSecondary(surnameView: String) {
        labelSecondary.text = surnameView
    }
    
    // MARK: - Private Methods
    private func settingsView() {
        view.addSubview(stackView)
        view.addSubview(imageArrow)
        stackView.addArrangedSubview(labelBasic)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageArrow.topAnchor.constraint(equalTo: view.topAnchor),
            imageArrow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -24),
            imageArrow.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        if labelSecondary.text != nil {
            stackView.addArrangedSubview(labelSecondary)
        }
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapView(_:))))
    }
}

//
//  ViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.11.2023.
//

import UIKit

class TrackerViewController: UIViewController {
    
    //MARK:  - Private Properties
    private var addSkillButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "addSkillButton")!,
            target: TrackerViewController?.self, action: #selector(pressAddSkillButton))
        button.tintColor = .black
        return button
    }()
    
    private var pageLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.backgroundColor = .backgrounfColorMayBe  //подобрать равильный цвет, разночтения в Фигме
        label.text = "25.01.24" //НУЖНО выравнить текст и поставить дату
        label.font = UIFont(name: "System", size: 17)
        label.textColor = .black
        return label
    }()

    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubView()
        applyConstraints()
    }

    //MARK:  - Private Methods
    private func addSubView(){
        view.addSubview(addSkillButton)
        view.addSubview(pageLabel)
        view.addSubview(dateLabel)
    }
    
    private func applyConstraints(){
        addSkillButton.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addSkillButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addSkillButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addSkillButton.widthAnchor.constraint(equalToConstant: 42),
            addSkillButton.heightAnchor.constraint(equalToConstant: 42),
            pageLabel.leadingAnchor.constraint(equalTo: addSkillButton.leadingAnchor, constant: 10),
            pageLabel.topAnchor.constraint(equalTo: addSkillButton.bottomAnchor, constant: 1),
            addSkillButton.widthAnchor.constraint(equalToConstant: 254),
            addSkillButton.heightAnchor.constraint(equalToConstant: 41),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: addSkillButton.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    @objc 
    private func pressAddSkillButton () {}

}


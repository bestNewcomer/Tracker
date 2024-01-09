//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 08.01.2024.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    //MARK:  - Private Properties
    private var pageLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
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
        view.addSubview(pageLabel)
    }
    
    private func applyConstraints(){
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            pageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
        ])
    }
}

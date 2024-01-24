//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 08.01.2024.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    //MARK:  - Private Properties
  
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navBarStatistics() // Не видно надписи Статистика - разобраться
        statisticsStub()
    }
    
    //MARK:  - Private Methods
    private func navBarStatistics () {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Статистика"
    }
    
    private func statisticsStub () {
        let stabImage: UIImageView = {
            let image = UIImageView(image: UIImage(named: "imageStatisticsStub"))
            return image
        }()
        
        let stubLabel: UILabel = {
            let label = UILabel()
            label.text = "Анализировать пока нечего"
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .black
            return label
        }()
        
        view.addSubview(stabImage)
        view.addSubview(stubLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        stabImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stabImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stabImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stabImage.widthAnchor.constraint(equalToConstant: 80),
            stabImage.heightAnchor.constraint(equalToConstant: 80),
            stubLabel.topAnchor.constraint(equalTo: stabImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}

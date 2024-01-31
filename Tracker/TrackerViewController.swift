//
//  ViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.11.2023.
//

import UIKit

class TrackerViewController: UIViewController {
    
    //MARK:  - Private Properties
   
    
    
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navBarTracker()
        trackerStub()
      
    }
    
    //MARK:  - Private Methods
    private func navBarTracker () {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Трекеры"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "addSkillButton")?.withRenderingMode(.alwaysOriginal),
            style: .plain ,
            target: TrackerViewController?.self,
            action: #selector(pressAddSkillButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem( // Сделать дата
            title: "14.12.22",
            style: .plain ,
            target: TrackerViewController?.self,
            action: #selector(pressData))
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
    }
    
    private func trackerStub () {
        let stabImage: UIImageView = {
            let image = UIImageView(image: UIImage(named: "imageTrackerStub"))
            return image
        }()
        
        let stubLabel: UILabel = {
            let label = UILabel()
            label.text = "Что будем отслеживать?"
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
   
    @objc
    private func pressAddSkillButton () {}
    
    @objc
    private func pressData () {}
}


//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 08.01.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        generateTabBar()
    }
    
    //MARK:  - Private Methods
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: TrackerViewController(),
                title: "Трекеры",
                image: UIImage(named: "imageTracker")
            ),
            generateVC(
                viewController: StatisticsViewController(),
                title: "Статистика",
                image: UIImage(named: "imageStatistics")
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}

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
        
//        view.backgroundColor = .ypWhiteDay
        generateTabBar()
        borderTabBar()
       
   
    }
    
    //MARK:  - Private Methods
    private func generateTabBar() {
        viewControllers = [
            UINavigationController(rootViewController: generateVC(
                viewController: TrackerViewController(),
                title: "mainTabBarController_tracker_title".localized,
                image: UIImage(named: "imageTracker"))
            ),
            UINavigationController(rootViewController: generateVC(
                viewController: StatisticsViewController(),
                title: "mainTabBarController_statistics_title".localized,
                image: UIImage(named: "imageStatistics"))
            )
        ]
        
    }
    
    private func borderTabBar () {
        tabBar.layer.borderColor = UIColor(named: "backgroundDay")?.cgColor
        tabBar.layer.borderWidth = 1.0
        tabBar.clipsToBounds = true
        tabBar.backgroundColor = .ypWhiteDay
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}

//
//  WindowNavigationViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 22.03.2024.
//

import UIKit
import Foundation

final class WindowNavigationViewController: UIViewController {
    
    // MARK: - Properties
    @UserDefaultsBacked(key: "isOnboardingShown")
    private var onboardingOn: Bool?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onboardingOn == true {
            showTabBarViewController()
        } else {
            showOnboardingViewController()
            onboardingOn = true
        }
    }
    
    // MARK: - Methods
    private func showOnboardingViewController() {
        let onboardingViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        UIApplication.shared.windows.first?.rootViewController = onboardingViewController
    }
    
    private func showTabBarViewController() {
        let tabBarViewController = MainTabBarController()
        UIApplication.shared.windows.first?.rootViewController = tabBarViewController
    }
}


@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String
    let storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            storage.value(forKey: key) as? Value
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
}

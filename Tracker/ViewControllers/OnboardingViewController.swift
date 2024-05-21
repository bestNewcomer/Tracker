//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 22.03.2024.
//

import UIKit
import Foundation

final class OnboardingViewController: UIPageViewController {
    
    //MARK:  - Private Properties
    private lazy var pages: [UIViewController] = {
        let firstOnboardingPage = OnboardingSinglePageViewController()
        firstOnboardingPage.onboardImage.image = UIImage(named: "imageBlueOnboard")
        firstOnboardingPage.textLabel.text = "onboarding_firstPageText".localized
        let secondOnboardingPage = OnboardingSinglePageViewController()
        secondOnboardingPage.onboardImage.image = UIImage(named: "imageRedOnboard")
        secondOnboardingPage.textLabel.text = "onboarding_secondPageText".localized
        return [firstOnboardingPage, secondOnboardingPage]
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlackDay
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("onboarding_button".localized, for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(nil, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        return pageControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        addSubViews()
        applyConstraint()
    }
    
    //MARK:  - Private Methods
    private func addSubViews() {
        [button, pageControl].forEach { view.addSubview($0) }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 60),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupDelegates() {
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
}

extension OnboardingViewController {
    @objc private func didTapButton() {
        let tabBarViewController = MainTabBarController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}



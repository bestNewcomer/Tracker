//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 10.02.2024.
//

import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    //MARK:  - Private Properties
    private 
    // MARK: - Initializers
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        
    }
    
    //MARK:  - Private Methods
    let scrollView: UIScrollView {
        let scrollView = UIScrollView()
        scroll
    }()
    var labelTest: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .red
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Label ХУЙ"
        return label
    }()
    
    var labelTest2: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .red
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.text = "Label ХУЙ"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        view.addSubview(scrollView)
        scrollView.addSubview(labelTest)
        scrollView.addSubview(labelTest2)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labelTest.translatesAutoresizingMaskIntoConstraints = false
        labelTest2.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       
    }

    
}

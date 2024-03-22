//
//  Devider.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 14.02.2024.
//

import UIKit

final class Divider: UIView {
    // MARK: - Private Properties
    private var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func settingsView() {
        addSubview(divider)
       
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            divider.centerXAnchor.constraint(equalTo: centerXAnchor),
            divider.centerYAnchor.constraint(equalTo: centerYAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}


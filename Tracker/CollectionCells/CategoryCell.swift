//
//  CategoriesCell.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 12.03.2024.
//

import Foundation
import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let cellID = "CategoriesCell"
    
    lazy var labelBasic: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    lazy var imageCheck: UIImageView = {
        let imVi = UIImageView()
        imVi.image = UIImage()
        imVi.contentMode = .scaleAspectFit
        imVi.image = UIImage(named: "imageCheckMark")
        return imVi
    }()
    
    // MARK: - Initializers
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        settingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func config(nameView: String, isActive: Bool) {
        labelBasic.text = nameView
        imageCheck.isHidden = !isActive
    }
    
    func config(nameView: String) {
        labelBasic.text = nameView
    }
    
    func configImage(isActive: Bool) {
        imageCheck.isHidden = !isActive

    }
    
    func getSelectedCategoryTitle() -> String {
        let selectedCategoryTitle = self.labelBasic.text

        return selectedCategoryTitle!
    }
    
    func selectImageCheck(image: String) {
        imageCheck.image = UIImage(named: image)
    }
    
    // MARK: - Private Methods
    private func settingsView() {
        contentView.addSubview(labelBasic)
        contentView.addSubview(imageCheck)
        
        labelBasic.translatesAutoresizingMaskIntoConstraints = false
        imageCheck.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .backgroundDay
        
        NSLayoutConstraint.activate([
            labelBasic.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelBasic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelBasic.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageCheck.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageCheck.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -24),
        ])
    }
}

//
//  CategoriesCell.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 12.03.2024.
//

import Foundation
import UIKit

final class CategoryCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let cellID = "CategoriesCell"
    
    lazy var labelBasic: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = "Важное"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    lazy var imageCheck: UIImageView = {
        let imVi = UIImageView()
        imVi.image = UIImage()
        imVi.contentMode = .scaleAspectFit
        return imVi
    }()
    
    var divider: UIView = {
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
    
    // MARK: - Actions
    @objc func didTapView(_ sender: UITapGestureRecognizer){
       
    }
    
    // MARK: - Public Methods
    func renamingLabelBasic(nameView: String) {
        labelBasic.text = nameView
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
        contentView.addSubview(divider)
        contentView.addSubview(labelBasic)
        contentView.addSubview(imageCheck)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        labelBasic.translatesAutoresizingMaskIntoConstraints = false
        imageCheck.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .backgroundDay
        
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            divider.centerXAnchor.constraint(equalTo: centerXAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            labelBasic.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelBasic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelBasic.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageCheck.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageCheck.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -24),
        ])
        
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapView(_:))))
    }
}

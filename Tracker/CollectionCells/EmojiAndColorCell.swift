//
//  EmojiAndColorCell.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 25.02.2024.
//

import Foundation
import UIKit

final class EmojiAndColorCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let cellID = "EmojiAndColorCell"
    
    // MARK: - Private Properties
    lazy var mainButtom: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(Self.tapСell), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellElementSettings()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc
    private func tapСell(){
        print("Кнопка создания работает")
    }
   
    // MARK: - Public Methods
    func customizeCell(emojiCell: String, colorCell: UIColor?) {
        mainButtom.setTitle(emojiCell, for: .normal)
        mainButtom.backgroundColor = colorCell
    }
    
    // MARK: - Private Methods
    private func cellElementSettings(){
        contentView.addSubview(mainButtom)
        
        mainButtom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainButtom.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainButtom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainButtom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

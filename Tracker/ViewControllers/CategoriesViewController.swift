//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 12.03.2024.
//

import Foundation
import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - Public Properties
    var trackerCategories = [TrackerCategory(title: "Важное"),
                             TrackerCategory(title: "Радостные мелочи"),
                             TrackerCategory(title: "Самочувствие")
    ]
    var onCategoriesUpdated: ((TrackerCategory) -> Void)?
    
    //MARK:  - Private Properties
    private var СategoriesCollectionView: UICollectionView!
    private let params: GeometricParams
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Категория")
        return label
    }()
    
    private lazy var addCategory: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(tapAddCategory), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init() {
        self.params = GeometricParams(cellCount: 1, leftInset: 0, rightInset: 0, cellSpacing: 0)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        subSettingsCollectionsView()
        settingsConstraints()
        
        СategoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellID)
    }
    
    // MARK: - Actions
    @objc private func tapAddCategory(){
        let jump = NewCategory()
        jump.modalPresentationStyle = .pageSheet
        present(jump, animated: true)
    }
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        СategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        СategoriesCollectionView.dataSource = self
        СategoriesCollectionView.delegate = self
        СategoriesCollectionView.layer.cornerRadius = 16
        СategoriesCollectionView.allowsMultipleSelection = false
    }
    
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(СategoriesCollectionView)
        scrollView.addSubview(addCategory)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        СategoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addCategory.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            СategoriesCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            СategoriesCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            СategoriesCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            СategoriesCollectionView.heightAnchor.constraint(equalToConstant: 225), //Пока так, потом придеться проставить зависимость от напонения
            
            addCategory.topAnchor.constraint(equalTo: labeltitle.bottomAnchor, constant: 651),
            addCategory.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addCategory.widthAnchor.constraint(equalToConstant: 335),
            addCategory.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as? CategoryCell else { fatalError("Failed to cast UICollectionViewCell to CategoriesCell") }
        cell.renamingLabelBasic(nameView: "\(trackerCategories[indexPath.row].title)")
        if indexPath.row == 0 {
            cell.divider.backgroundColor = .backgroundDay
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

//простая но несколько кривая реализация, так как приходится  "выделять" ячейку , а не просто тапать по ней, потом поменять метод 
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
        cell?.selectCategory(image: "imageCheckMark")
       }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
        cell?.selectCategory(image: "")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = СategoriesCollectionView.frame.width - params.paddingWidth
        let availableHeight = СategoriesCollectionView.frame.height
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        let cellHeight = availableHeight / CGFloat(trackerCategories.count)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    // расстояние между ячейками по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    // расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(params.cellSpacing)
    }
}

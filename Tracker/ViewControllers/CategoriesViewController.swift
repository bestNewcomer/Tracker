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
    var onCategoriesUpdated: ((TrackerCategory) -> Void)?
    var trackerViewController = TrackerViewController()
    var checkButtonValidation: (() -> Void)?
    
    //MARK:  - Private Properties
    private var categoriesCollectionView: UICollectionView!
    private let params: GeometricParams
    private let trackerCategoryStore = TrackerCategoryStore.shared
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
    }
    
    // MARK: - Actions
    @objc private func tapAddCategory(){
        let jump = NewCategoryViewController()
        jump.modalPresentationStyle = .pageSheet
        present(jump, animated: true)
    }
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellID)
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.layer.cornerRadius = 16
        categoriesCollectionView.allowsMultipleSelection = false
    }
    
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(categoriesCollectionView)
        scrollView.addSubview(addCategory)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addCategory.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            categoriesCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 150), //Пока так, потом придеться проставить зависимость от напонения
            
            addCategory.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategory.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addCategory.widthAnchor.constraint(equalToConstant: 335),
            addCategory.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerViewController.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as? CategoryCell else { fatalError("Failed to cast UICollectionViewCell to CategoriesCell") }
        cell.renamingLabelBasic(nameView: "\(trackerViewController.categories[indexPath.row].title)")
        if indexPath.row == 0 {
            cell.divider.backgroundColor = .backgroundDay
        }
        cell.jump = { [self] in
            self.updateCategories(categoryIndex: indexPath.row)
            onCategoriesUpdated?(trackerViewController.categories[indexPath.row])
            checkButtonValidation?()
            dismiss(animated: true, completion: nil)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, 
                            left: params.leftInset,
                            bottom: 0,
                            right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = categoriesCollectionView.frame.width - params.paddingWidth
        let availableHeight = categoriesCollectionView.frame.height
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        let cellHeight = availableHeight / CGFloat(trackerViewController.categories.count)
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

extension CategoriesViewController {
    func updateCategories(categoryIndex: Int) {
//        let category = trackerViewController.categories[categoryIndex].title
        
        categoriesCollectionView.reloadItems(at: [IndexPath(row: categoryIndex, section: 0)])
    }
}

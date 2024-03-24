//
//  FilterViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 15.03.2024.
//

import Foundation
import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - Public Properties
    private let filterList = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    //MARK:  - Private Properties
    private var filterCollectionView: UICollectionView!
    private let params: GeometricParams
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Фильтры")
        return label
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
        
        filterCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellID)
    }
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.layer.cornerRadius = 16
        filterCollectionView.allowsMultipleSelection = false
    }
    
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(filterCollectionView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            filterCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            filterCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            filterCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 300), 
            
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as? CategoryCell else { fatalError("Failed to cast UICollectionViewCell to CategoriesCell") }
        cell.renamingLabelBasic(nameView: "\(filterList[indexPath.row])")
        if indexPath.row == 0 {
            cell.divider.backgroundColor = .backgroundDay
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

//простая но несколько кривая реализация, так как приходится  "выделять" ячейку , а не просто тапать по ней, потом поменять метод
extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
        cell?.selectImageCheck(image: "imageCheckMark")
       }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
        cell?.selectImageCheck(image: "")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, 
                            left: params.leftInset,
                            bottom: 0,
                            right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = filterCollectionView.frame.width - params.paddingWidth
        let availableHeight = filterCollectionView.frame.height
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        let cellHeight = availableHeight / CGFloat(filterList.count)
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

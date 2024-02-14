//
//  ViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.11.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    
    
    
    
    
    //MARK:  - Private Properties
    private var trackersCollectionView: UICollectionView!
    
    
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        
        navBarTracker()
        trackerStub()
        settingsCollectionView()
        trackersCollectionView.register(TrackerCollectionCell.self, forCellWithReuseIdentifier: TrackerCollectionCell.cellID)
        trackersCollectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.headerID)
        
    }
    
    // MARK: - Actions
    @objc
    private func pressAddSkillButton () {
        let jump = ChoiceTrackerViewController()
        jump.modalPresentationStyle = .pageSheet
        present(jump, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    
    //MARK:  - Private Methods
    private func navBarTracker () {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Трекеры"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "addSkillButton")?.withRenderingMode(.alwaysOriginal),
            style: .plain ,
            target: self,
            action: #selector(pressAddSkillButton))
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.locale = Locale(identifier: "ru_RU")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
    }
    // добавить условие отображения заглушки или коллекции
    private func displayCondition() {
        
    }
    
    private func settingsCollectionView() {
        trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
    
    private func trackerStub () {
        let stabImage: UIImageView = {
            let image = UIImageView(image: UIImage(named: "imageTrackerStub"))
            return image
        }()
        
        let stubLabel: UILabel = {
            let label = UILabel()
            label.text = "Что будем отслеживать?"
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .ypBlackDay
            return label
        }()
        
        view.addSubview(stabImage)
        view.addSubview(stubLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        stabImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stabImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stabImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stabImage.widthAnchor.constraint(equalToConstant: 80),
            stabImage.heightAnchor.constraint(equalToConstant: 80),
            stubLabel.topAnchor.constraint(equalTo: stabImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func makeSecure(indexPath: IndexPath) {
        //let cell = trackersCollectionView.cellForItem(at: indexPath) as? TrackerCollectionCell
        //cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private func makeEdit(indexPath: IndexPath) {
        //let cell = trackersCollectionView.cellForItem(at: indexPath) as? TrackerCollectionCell
        //cell?.titleLabel.font = UIFont.italicSystemFont(ofSize: 17)
    }
    
    private func makeDelete(indexPath: IndexPath) {
        //let cell = trackersCollectionView.cellForItem(at: indexPath) as? TrackerCollectionCell
        //cell?.titleLabel.font = UIFont.italicSystemFont(ofSize: 17)
    }
    
    
    
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    // количество ячеек в разделе
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    //Количество разделов в коллекции
    func numberOfSections(in: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionCell.cellID, for: indexPath) as? TrackerCollectionCell else { fatalError("Failed to cast UICollectionViewCell to TrackersCell") }
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = trackersCollectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: TrackerSupplementaryView.headerID,for: indexPath) as? TrackerSupplementaryView
            else { fatalError("Failed to cast UICollectionReusableView to TrackersHeader") }
            
            header.titleLabel.text = "Домашний уют" //categories[indexPath.section].title
            return header
        default:
            fatalError("Unexpected element kind")
        }
    }
    // контекстное меню ячейки 
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Закрепить") { [weak self] _ in
                    self?.makeSecure(indexPath: indexPath)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.makeEdit(indexPath: indexPath)
                },
                UIAction(title: "Удалить") { [weak self] _ in
                    self?.makeDelete(indexPath: indexPath) // добавить красный цвет
                },
            ])
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    // расстояние между ячейками по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    // расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 2, section: section)
        let headerView = self.collectionView(trackersCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: trackersCollectionView.frame.width,height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
    }
    
}


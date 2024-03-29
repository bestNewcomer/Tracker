//
//  ViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.11.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
  
    //MARK:  - Private Properties
    private var trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params: GeometricParams
    private var currentDate: Date = Date()
    private var isSearching = false
    private var searchText: String = ""
    private var visibleCategories: [TrackerCategory] = []
    private var completedTracker: [TrackerRecord] = []
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var  stubImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "imageTrackerStub"))
        return image
    }()
    
    private lazy var  stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    // MARK: - Initialization
    init() {
        self.params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        
        hideKeyboard()
        trackerStub()
        reloadVisibleCategories()
        settingsCollectionView()
        navBarTracker()
        
        completedTracker = trackerRecordStore.trackerRecords
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        creatingFilter()
    }
    
    // MARK: - Actions
    @objc private func pressAddSkillButton () {
        let jump = ChoiceTrackerViewController()
        jump.delegate = self
        jump.modalPresentationStyle = .pageSheet
        jump.onTrackerCreated = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
        present(jump, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        reloadVisibleCategories()
    }
    
    @objc private func tapFilterSelection () {
//        let jump = FilterViewController()
//        jump.modalPresentationStyle = .pageSheet
//        present(jump, animated: true)
    }
    
    
    //MARK:  - Private Methods
    private func creatingFilter() {
        let filterButton: UIButton = {
            let button = UIButton()
            button.tintColor = .white
            button.backgroundColor = .ypBlue
            button.setTitle("Фильтры", for: .normal)
            button.layer.cornerRadius = 16
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            button.addTarget(self, action: #selector(Self.tapFilterSelection), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.isHidden = false
        NSLayoutConstraint.activate([
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func navBarTracker () {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Трекеры"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "addSkillButton")?.withRenderingMode(.alwaysOriginal),
            style: .plain ,
            target: self,
            action: #selector(pressAddSkillButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    private func settingsCollectionView() {
        
        
        trackersCollectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.cellID)
        trackersCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        view.addSubview(trackersCollectionView)
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func trackerStub () {
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        stubImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        stubImage.isHidden = true
        stubLabel.isHidden = true
    }
    
//    private func isTrackerCompletedOnCurrentDate(trackerId: UUID) -> Bool {
//        return completedTracker.contains(where: { $0.idRecord == trackerId && Calendar.current.isDate($0.dateRecord, inSameDayAs: currentDate)})
//    }
    
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
    
    private func updateView() {
        let hasTrackersToShow = !visibleCategories.flatMap { $0.trackersArray }.isEmpty
        stubImage.isHidden = hasTrackersToShow
        stubLabel.isHidden = hasTrackersToShow
        trackersCollectionView.isHidden = !hasTrackersToShow
        
        stubLabel.text = isSearching ? "Ничего не найдено" : "Что будем отслеживать?"
        stubImage.image = UIImage(named: isSearching ? "imageSearchStub" : "imageTrackerStub")
    }
    
    private func reloadVisibleCategories() {
        var newCategories = [TrackerCategory]()
        visibleCategories = trackerCategoryStore.trackerCategories

        for category in visibleCategories {
            var newTrackers = [Tracker]()
            for tracker in category.visibleTrackers(filterString: searchText) {
                guard let timetable = tracker.timetable else { return }
                let timetableIntegers = timetable.map { $0.rawValue }
                if let day = DaysOfWeek(rawValue: currentDate.toWeekday().rawValue),
                   timetableIntegers.contains(day.rawValue) &&
                    (searchText.isEmpty || tracker.name.lowercased().contains(searchText.lowercased())) {
                    newTrackers.append(tracker)
                }
            }
            
            if newTrackers.count > 0 {
                let newCategory = TrackerCategory(
                    title: category.title,
                    trackersArray: newTrackers
                )
                newCategories.append(newCategory)
            }
        }
        visibleCategories = newCategories
        trackersCollectionView.reloadData()
        updateView()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    // количество ячеек в разделе
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackersArray.count
    }
    //Количество разделов в коллекции
    func numberOfSections(in: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.cellID, for: indexPath) as? TrackerCell else { fatalError("Failed to cast UICollectionViewCell to TrackersCell")
        }
        
        let tracker = visibleCategories[indexPath.section].trackersArray[indexPath.row]
        cell.delegate = self
        let isCompleted = completedTracker.contains(where: { trackerRecord in
            trackerRecord.idRecord == tracker.id &&
            trackerRecord.dateRecord.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        })
        let completedDays = completedTracker.filter {$0.idRecord == tracker.id}.count
        
        cell.customizeCell(
            tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            completedDays: completedDays, 
            isCompleted: isCompleted
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = trackersCollectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: SpecialSectionHeader.headerID,for: indexPath) as? SpecialSectionHeader
            else { fatalError("Failed to cast UICollectionReusableView to TrackersHeader") }
            
            header.titleLabel.text = visibleCategories[indexPath.section].title
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
        return UIEdgeInsets(top: 12,
                            left: params.leftInset,
                            bottom: 16,
                            right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let avaliableWidth = trackersCollectionView.bounds.width - params.paddingWidth
        let widthPerItem = avaliableWidth / CGFloat(params.cellCount)
        let heightPerItem = widthPerItem * (148 / 176)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    // расстояние между ячейками по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    // расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        let indexPath = IndexPath(row: 2, section: section)
        let headerView = self.collectionView(trackersCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: trackersCollectionView.frame.width,height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - NewTrackerCreationDelegate
extension TrackerViewController: NewTrackerCreationDelegate {
    func trackerCreated(_ tracker: Tracker, _ category: String) {
        
        var updatedCategory: TrackerCategory?
        let categories: [TrackerCategory] = trackerCategoryStore.trackerCategories
        
        for item in 0..<categories.count {
            if categories[item].title == category {
                updatedCategory = categories[item]
            }
        }
        
        if updatedCategory != nil {
            try? trackerCategoryStore.addTrackerToCategory(tracker, to: updatedCategory ?? TrackerCategory(
                title: category,
                trackersArray: [tracker]
            ))
        } else {
            let trackerCategory = TrackerCategory(
                title: category,
                trackersArray: [tracker]
            )
            updatedCategory = trackerCategory
            try? trackerCategoryStore.addNewTrackerCategory(updatedCategory ?? TrackerCategory(
                title: category,
                trackersArray: [tracker]
            ))
        }
        reloadVisibleCategories()
    }
}
// MARK: - TrackersCellDelgate
extension TrackerViewController: TrackerCellDelegate {
    func trackerCompleted(id: UUID) {
        if let index = completedTracker.firstIndex(where: { trackerRecord in
            trackerRecord.idRecord == id &&
            trackerRecord.dateRecord.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        }) {
            completedTracker.remove(at: index)
            try? trackerRecordStore.deleteTrackerRecord(with: id, date: datePicker.date)
        } else {
            completedTracker.append(TrackerRecord(dateRecord: datePicker.date, idRecord: id))
            try? trackerRecordStore.addNewTracker(TrackerRecord(dateRecord: datePicker.date, idRecord: id))
        }
        reloadVisibleCategories()
        trackersCollectionView.reloadData()
        trackerRecordStore.reload()
    }
}

// MARK: - TrackerCreationDelegate
extension TrackerViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        if searchText.isEmpty {
            visibleCategories = trackerCategoryStore.trackerCategories
        } else {
            visibleCategories = trackerCategoryStore.trackerCategories.map { category in
                let filteredTrackers = category.trackersArray.filter { tracker in
                    return tracker.name.localizedCaseInsensitiveContains(searchText)
                }
                return TrackerCategory(title: category.title, trackersArray: filteredTrackers)
            }.filter { !$0.trackersArray.isEmpty }
        }
        trackersCollectionView.reloadData()
        updateView()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        isSearching = false
        updateView()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        trackersCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchText = ""
        reloadVisibleCategories()
        
    }
}

// MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        reloadVisibleCategories()
        trackersCollectionView.reloadData()
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackerViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        reloadVisibleCategories()
        trackersCollectionView.reloadData()
    }
}

// MARK: - TrackerRecordStoreDelegate
extension TrackerViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        completedTracker = trackerRecordStore.trackerRecords
        trackersCollectionView.reloadData()
    }
}
// MARK: - Extension Recognizer
extension TrackerViewController {
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


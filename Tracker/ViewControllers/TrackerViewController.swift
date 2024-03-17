//
//  ViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 13.11.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    //MARK:  - Public Properties
    var categories: [TrackerCategory] = [TrackerCategory(title: "По умолчанию", trackersArray: [])]
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    //MARK:  - Private Properties
    private var TrackersCollectionView: UICollectionView!
    private let params: GeometricParams
    private var currentDate: Date = Date()
    private var completedTrackerIds = Set<UUID>()
    private var searchText = ""
    private var isSearching = false
    
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
    
    private lazy var  stabImage: UIImageView = {
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
        
        trackerStub()
        settingsCollectionView()
        navBarTracker()
        categories = TestData.shared.getDummyTrackers()
        filterTrackersForSelectedDate()
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
        filterTrackersForSelectedDate()
        TrackersCollectionView.reloadData()
    }
    
    @objc private func tapFilterSelection () {
        let jump = FilterViewController()
        jump.modalPresentationStyle = .pageSheet
        present(jump, animated: true)
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
        TrackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        TrackersCollectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.cellID)
        TrackersCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
        
        TrackersCollectionView.dataSource = self
        TrackersCollectionView.delegate = self
        
        view.addSubview(TrackersCollectionView)
        
        TrackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            TrackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            TrackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            TrackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            TrackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func trackerStub () {
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
        
        stabImage.isHidden = true
        stubLabel.isHidden = true
    }
    
    private func isTrackerCompletedOnCurrentDate(trackerId: UUID) -> Bool {
        return completedTrackers.contains(where: { $0.idRecord == trackerId && Calendar.current.isDate($0.dateRecord, inSameDayAs: currentDate)})
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
    
    private func filterTrackersForSelectedDate() {
        let dayOfWeek = currentDate.toWeekday()
        visibleCategories = categories.map { category in
            let filteredTrackers = category.trackersArray.filter { tracker in
                guard let schedule = tracker.timetable else { return true }
                return schedule.isReccuringOn(dayOfWeek)
            }
            return TrackerCategory(title: category.title, trackersArray: filteredTrackers)
        }.filter { !$0.trackersArray.isEmpty }
        
        updateView()
    }
    
    private func updateView() {
        let hasTrackersToShow = !visibleCategories.flatMap { $0.trackersArray }.isEmpty
        stabImage.isHidden = hasTrackersToShow
        stubLabel.isHidden = hasTrackersToShow
        TrackersCollectionView.isHidden = !hasTrackersToShow
        
        stubLabel.text = isSearching ? "Ничего не найдено" : "Что будем отслеживать?"
    }
    
    private func countCompletedDays(for trackerId: UUID) -> Int {
        let completedDates = completedTrackers.filter { $0.idRecord == trackerId }.map { $0.dateRecord }
        let uniqueDates = Set(completedDates)
        return uniqueDates.count
    }
    
    private func toggleTrackerCompleted(trackerId: UUID, at indexPath: IndexPath) {
        if isTrackerCompletedOnCurrentDate(trackerId: trackerId) {
            completedTrackerIds.remove(trackerId)
            completedTrackers.removeAll {$0.idRecord == trackerId && Calendar.current.isDate($0.dateRecord, inSameDayAs: currentDate)}
        } else {
            completedTrackerIds.insert(trackerId)
            let newRecord = TrackerRecord(idRecord: trackerId, dateRecord: currentDate)
            completedTrackers.append(newRecord)
        }
        UIView.performWithoutAnimation {
            TrackersCollectionView.reloadItems(at: [indexPath])
        }
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
        cell.isCompleted = completedTrackerIds.contains(tracker.id) && isTrackerCompletedOnCurrentDate(trackerId: tracker.id)
        let daysCount = countCompletedDays(for: tracker.id)
        cell.customizeCell(name: visibleCategories[indexPath.section].trackersArray[indexPath.row].name, color: visibleCategories[indexPath.section].trackersArray[indexPath.row].color, emoji: visibleCategories[indexPath.section].trackersArray[indexPath.row].emoji, completedDays: daysCount)
        
        cell.onToggleCompleted = { [weak self] in
            guard let self = self, self.currentDate <= Date() else { return }
            cell.isCompleted.toggle()
            self.toggleTrackerCompleted(trackerId: tracker.id, at: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = TrackersCollectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: SpecialSectionHeader.headerID,for: indexPath) as? SpecialSectionHeader
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
        let avaliableWidth = TrackersCollectionView.bounds.width - params.paddingWidth
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
        let headerView = self.collectionView(TrackersCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: TrackersCollectionView.frame.width,height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - NewTrackerCreationDelegate
extension TrackerViewController: NewTrackerCreationDelegate {
    func trackerCreated(_ tracker: Tracker, _ category: String) {
        var newTrackers = categories[1].trackersArray
        newTrackers.append(tracker)
        
        let updateCategory = TrackerCategory(title: categories[1].title, trackersArray: newTrackers)
        
        categories[1] = updateCategory
        filterTrackersForSelectedDate()
        TrackersCollectionView.reloadData()
    }
    
//    func categoryCreated(_ category: TrackerCategory) {
//        var newCategory = categories
//        
//        newCategory.append(category)
//        categories = newCategory
//        filterTrackersForSelectedDate()
//        TrackersCollectionView.reloadData()
//    
//    }
}

// MARK: - TrackerCreationDelegate
extension TrackerViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        if searchText.isEmpty {
            visibleCategories = categories
        } else {
            visibleCategories = categories.map { category in
                let filteredTrackers = category.trackersArray.filter { tracker in
                    return tracker.name.localizedCaseInsensitiveContains(searchText)
                }
                return TrackerCategory(title: category.title, trackersArray: filteredTrackers)
            }.filter { !$0.trackersArray.isEmpty }
        }
        TrackersCollectionView.reloadData()
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
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchText = ""
        TrackersCollectionView.reloadData()
    }
}

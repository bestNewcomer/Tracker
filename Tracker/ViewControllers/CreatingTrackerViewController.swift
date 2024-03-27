//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 10.02.2024.
//

import UIKit

protocol NewTrackerCreationDelegate: AnyObject {
    func trackerCreated(_ tracker: Tracker, _ category: String)
    
}

final class CreatingTrackerViewController: UIViewController {
    // MARK: - Public Properties
    let emojis  = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝️","😪"]
    let colors: [UIColor] = [.colorSelection1,.colorSelection2,.colorSelection3,.colorSelection4,.colorSelection5,.colorSelection6,.colorSelection7,.colorSelection8,.colorSelection9,.colorSelection10,.colorSelection11,.colorSelection12,.colorSelection13,.colorSelection14,.colorSelection15,.colorSelection16,.colorSelection17,.colorSelection18]
    weak var delegate: NewTrackerCreationDelegate?
    var onCompletion: (() -> Void)?
    var habitIndicator = true
    
    //MARK:  - Private Properties
    private var emojisCollectionView: UICollectionView!
    private var colorsCollectionView: UICollectionView!
    private let params: GeometricParams
    private var selectedSchedule: [DaysOfWeek] = []
    private var category: TrackerCategory?
    private var completedTracker: [TrackerRecord] = []
    private let trackerRecordStore = TrackerRecordStore()
    private var formattedSchedule: String = "" {
        didSet {
            checkButtonValidation()
        }
    }
    private var formattedCategories: String = "" {
        didSet {
            checkButtonValidation()
        }
    }
    private var selectedEmoji: String = "" {
        didSet {
            checkButtonValidation()
        }
    }
    private var selectedColor: UIColor? = nil {
        didSet {
            checkButtonValidation()
        }
    }
    
    private let labelTitle: SpecialHeader = {
        let label = SpecialHeader()
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 164) //+38
    }
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "creatingTracker_textField_placeholder".localized
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .backgroundDay
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.resignFirstResponder()
        return textField
    }()
    
    private let labelRestrictions: UILabel = {
        let label = UILabel()
        label.text = "creatingTracker_limit_text".localized
        label.textColor = .ypRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .backgroundDay
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    private lazy var viewCategories: SpecialView = {
        let specialView = SpecialView()
        specialView.renamingLabelBasic(nameView: "creatingTracker_category_button".localized)
        specialView.jump = { [weak self] in
            self?.updateButtonCategories()
        }
        return specialView
    }()
    
    private lazy var viewSchedule: SpecialView = {
        let specialView = SpecialView()
        specialView.renamingLabelBasic(nameView: "creatingTracker_timetable_button".localized)
        specialView.jump = { [weak self] in
            self?.updateButtonSchedule()
        }
        return specialView
    }()
    
    private lazy var divider: Divider = {
        let view = Divider()
        return view
    }()
    
    private lazy var lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("creatingTracker_cancel_button".localized, for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tapСancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var  createButton: UIButton = {
        let button = UIButton()
        button.setTitle("creatingTracker_create_button".localized, for: .normal)
        button.setTitleColor(UIColor(named: "ypWhiteDay"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapСreateButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init() {
        self.params = GeometricParams(cellCount: 6, leftInset: 0, rightInset: 0, cellSpacing: 5)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        
        hubitOrIrregular()
        subSettingsCollectionsView()
        settings()
        nameTextField.delegate = self
        checkButtonValidation()
    }
    
    // MARK: - Actions
    @objc
    private func tapСancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func tapСreateButton(){
        let trackerName = nameTextField.text ?? ""
        guard let categoryName = category?.title else {
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            name: trackerName,
            color: selectedColor ?? .colorSelection1,
            emoji: selectedEmoji,
            timetable: habitIndicator ? selectedSchedule : [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday, ]
        )
        delegate?.trackerCreated(tracker, categoryName)
        onCompletion?()
        dismiss(animated: false, completion: nil)
    }
    
    //MARK:  - Public Methods
    func hubitOrIrregular() {
        if habitIndicator == true {
            labelTitle.customizeHeader(nameHeader: "creatingTracker_habit_title".localized)
        } else {
            labelTitle.customizeHeader(nameHeader: "creatingTracker_hirregular_title".localized)
        }
    }
    
    func updateButtonSchedule() {
        let scheduleViewController = ScheduleViewController(daysWeek: selectedSchedule)
        scheduleViewController.delegate = self
        viewSchedule.renamingLabelSecondary(surnameView: formattedSchedule)
        scheduleViewController.modalPresentationStyle = .pageSheet
        present(scheduleViewController, animated: true)
    }
//        schedule.onScheduleUpdated = { [weak self] updatedSchedule in
//            self?.selectedSchedule = updatedSchedule
//            self?.formattedSchedule = Schedule(markedDays: updatedSchedule).scheduleText
//            self?.viewSchedule.renamingLabelBasic(nameView: "creatingTracker_timetable_button".localized)
//            self?.viewSchedule.renamingLabelSecondary(surnameView: self?.formattedSchedule ?? "Schedule not working")
//        }
       
    
    func updateButtonCategories() {
        let categoriesViewController = CategoriesViewController(delegate: self, selectedCategories: category)
        viewCategories.renamingLabelBasic(nameView: "creatingTracker_category_button".localized)
            viewCategories.renamingLabelSecondary(surnameView: formattedCategories)
            categoriesViewController.modalPresentationStyle = .pageSheet
            present(categoriesViewController, animated: true)
        
    }
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        emojisCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojisCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.cellID)
        emojisCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
        emojisCollectionView.dataSource = self
        emojisCollectionView.delegate = self
        emojisCollectionView.isScrollEnabled = false
        emojisCollectionView.allowsMultipleSelection = false
        
        colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.cellID)
        colorsCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.isScrollEnabled = false
        colorsCollectionView.allowsMultipleSelection = false
    }
    
    private func settings() {
        view.addSubview(scrollView)
        view.addSubview(labelTitle)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(stackView)
        scrollView.addSubview(emojisCollectionView)
        scrollView.addSubview(colorsCollectionView)
        contentView.addSubview(lowerStackView)
        lowerStackView.addArrangedSubview(cancelButton)
        lowerStackView.addArrangedSubview(createButton)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        emojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 87),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            emojisCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            emojisCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojisCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            colorsCollectionView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 34),
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            lowerStackView.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 16),
            lowerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lowerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            lowerStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        if habitIndicator == true {
            stackView.addArrangedSubview(viewCategories.view)
            stackView.addArrangedSubview(divider)
            stackView.addArrangedSubview(viewSchedule.view)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
                stackView.heightAnchor.constraint(equalToConstant: 150),
            ])
        } else {
            stackView.addArrangedSubview(viewCategories.view)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
                stackView.heightAnchor.constraint(equalToConstant: 75),
            ])
        }
    }
    
    private func settingsRestrictions() {
        scrollView.addSubview(labelRestrictions)
        
        labelRestrictions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelRestrictions.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            labelRestrictions.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelRestrictions.heightAnchor.constraint(equalToConstant: 22),
            
            stackView.topAnchor.constraint(equalTo: labelRestrictions.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func deleteLabelRestrictions() {
        labelRestrictions.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func checkButtonValidation() {
        if nameTextField.text?.count == 0 {
            buttonIsEnable = false
            return
        }
        if category == nil {
            buttonIsEnable = false
            return
        }
        if habitIndicator == true {
            if formattedSchedule == "" {
                buttonIsEnable = false
                return
            }
        }
        if selectedEmoji == "" {
            buttonIsEnable = false
            return
        }
        if selectedColor == nil {
            buttonIsEnable = false
            return
        }
        buttonIsEnable = true
    }
    
    private var buttonIsEnable = false {
        willSet {
            if newValue {
                createButton.backgroundColor = UIColor(named: "ypBlackDay")
                createButton.setTitleColor(UIColor(named: "ypWhiteDay"), for: .normal)
                createButton.isEnabled = true
            } else {
                createButton.backgroundColor = UIColor(named: "ypGray")
                createButton.setTitleColor(UIColor(named: "ypWhiteDay"), for: .normal)
                createButton.isEnabled = false
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreatingTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.nameTextField {
            let currentLength = textField.text?.count ?? 0
            checkButtonValidation()
            if currentLength + string.count > 38 {
                settingsRestrictions()
                return false
            } else {
                deleteLabelRestrictions()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension CreatingTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCell.cellID, for: indexPath) as? EmojiAndColorCell else { fatalError("Failed to cast UICollectionViewCell to EmojiAndColorCell") }
        if collectionView == emojisCollectionView {
            cell.customizeCell(emojiCell: emojis[indexPath.row], colorCell: nil)
            return cell
        } else {
            cell.customizeCell(emojiCell: "", colorCell: colors[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: SpecialSectionHeader.headerID,for: indexPath) as? SpecialSectionHeader
            else { fatalError("Failed to cast UICollectionReusableView to SpecialSectionHeader") }
            if collectionView == emojisCollectionView {
                header.titleLabel.text = "creatingTracker_collectionEmoji_header".localized
                header.frame.origin.x = CGFloat(-20)
                return header
            } else {
                header.titleLabel.text = "creatingTracker_collectionColor_header".localized
                header.frame.origin.x = CGFloat(-20)
                return header
            }
        default:
            fatalError("Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CreatingTrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell
        
        if collectionView == emojisCollectionView {
            selectedEmoji = emojis[indexPath.item]
            cell?.allocationCell(emojiCell: true, allocationColor: .ypLightGray)
        } else {
            selectedColor = colors[indexPath.item]
            cell?.allocationCell(emojiCell: false, allocationColor: selectedColor ?? .black)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell
        
        if collectionView == emojisCollectionView {
            cell?.contentView.backgroundColor = .ypWhiteDay
        } else {
            cell?.contentView.layer.borderColor = UIColor.ypWhiteDay.cgColor
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreatingTrackerViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24,
                            left: params.leftInset,
                            bottom: 24,
                            right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth - 20.666
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    // расстояние между ячейками по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    // расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(params.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - TrackerRecordStoreDelegate
extension CreatingTrackerViewController: TrackerRecordStoreDelegate {
    func store(
        _ store: TrackerRecordStore,
        didUpdate update: TrackerRecordStoreUpdate
    ) {
        completedTracker = trackerRecordStore.trackerRecords
    }
}

// MARK: - CategoriesViewModelDelegate
extension CreatingTrackerViewController: CategoriesViewModelDelegate {
    func didSelectCategory(category: TrackerCategory) {
        self.category = category
        formattedCategories = category.title
        self.viewCategories.renamingLabelSecondary(surnameView: self.formattedCategories)
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreatingTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(activeDays: [DaysOfWeek]) {
        self.selectedSchedule = activeDays
        formattedSchedule = Schedule(markedDays: activeDays).scheduleText
        self.viewSchedule.renamingLabelSecondary(surnameView: self.formattedSchedule)
}
}

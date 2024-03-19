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
    var indication = 3
    
    //MARK:  - Private Properties
    private var EmojisCollectionView: UICollectionView!
    private var ColorsCollectionView: UICollectionView!
    private let params: GeometricParams
    private var selectedSchedule: Schedule?
    private var selectedCategories: TrackerCategory?
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
        textField.placeholder = "Введите название трекера"
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
        label.text = "Ограничение 38 символов"
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
        specialView.renamingLabelBasic(nameView: "Категория")
        specialView.jump = { [weak self] in
            self?.updateButtonCategories()
        }
        return specialView
    }()
    
    private lazy var viewSchedule: SpecialView = {
        let specialView = SpecialView()
        specialView.renamingLabelBasic(nameView: "Расписание")
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
        button.setTitle("Отменить", for: .normal)
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
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
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
        guard let categoryName = selectedCategories?.title else {
            return
        }
        let tracker = Tracker(
            id: UUID(),
            name: trackerName,
            color: selectedColor ?? .colorSelection1,
            emoji: selectedEmoji,
            timetable: selectedSchedule
        )
        delegate?.trackerCreated(tracker, categoryName)
        onCompletion?()
        dismiss(animated: false, completion: nil)
    }
    
    //MARK:  - Public Methods
    func hubitOrIrregular() {
        if habitIndicator == true {
            labelTitle.customizeHeader(nameHeader: "Новая привычка")
        } else {
            labelTitle.customizeHeader(nameHeader: "Новое нерегулярное событие")
        }
    }
    
    func updateButtonSchedule() {
        let schedule = ScheduleViewController()
        schedule.onScheduleUpdated = { [weak self] updatedSchedule in
            self?.selectedSchedule = updatedSchedule
            self?.formattedSchedule = updatedSchedule.scheduleText
            self?.viewSchedule.renamingLabelBasic(nameView: "Расписание")
            self?.viewSchedule.renamingLabelSecondary(surnameView: self?.formattedSchedule ?? "расписание не работает")
        }
        schedule.modalPresentationStyle = .pageSheet
        present(schedule, animated: true)
    }
    
    func updateButtonCategories() {
        let сategories = CategoriesViewController()
        сategories.onCategoriesUpdated = { [weak self] updatedСategories in
            self?.selectedCategories = updatedСategories
            self?.formattedCategories =  updatedСategories.title
            self?.viewCategories.renamingLabelBasic(nameView: "Категория")
            self?.viewCategories.renamingLabelSecondary(surnameView: self?.formattedCategories ?? "категории не работают")
            
        }
        сategories.modalPresentationStyle = .pageSheet
        present(сategories, animated: true)
    }
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        EmojisCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        EmojisCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.cellID)
        EmojisCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
        EmojisCollectionView.dataSource = self
        EmojisCollectionView.delegate = self
        EmojisCollectionView.isScrollEnabled = false
        EmojisCollectionView.allowsMultipleSelection = false
        
        ColorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        ColorsCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.cellID)
        ColorsCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
        ColorsCollectionView.dataSource = self
        ColorsCollectionView.delegate = self
        ColorsCollectionView.isScrollEnabled = false
        ColorsCollectionView.allowsMultipleSelection = false
    }
    
    private func settings() {
        view.addSubview(scrollView)
        view.addSubview(labelTitle)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(stackView)
        scrollView.addSubview(EmojisCollectionView)
        scrollView.addSubview(ColorsCollectionView)
        contentView.addSubview(lowerStackView)
        lowerStackView.addArrangedSubview(cancelButton)
        lowerStackView.addArrangedSubview(createButton)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        EmojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ColorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 87),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            EmojisCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            EmojisCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            EmojisCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            EmojisCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            ColorsCollectionView.topAnchor.constraint(equalTo: EmojisCollectionView.bottomAnchor, constant: 34),
            ColorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            ColorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            ColorsCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            lowerStackView.topAnchor.constraint(equalTo: ColorsCollectionView.bottomAnchor, constant: 16),
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
        if formattedCategories == "" {
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
                createButton.backgroundColor = .ypBlackDay
                createButton.setTitleColor(.ypWhiteDay, for: .normal)
                createButton.isEnabled = true
            } else {
                createButton.backgroundColor = .ypGray
                createButton.setTitleColor(.ypWhiteDay, for: .normal)
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
}

// MARK: - UICollectionViewDataSource
extension CreatingTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCell.cellID, for: indexPath) as? EmojiAndColorCell else { fatalError("Failed to cast UICollectionViewCell to EmojiAndColorCell") }
        if collectionView == EmojisCollectionView {
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
            if collectionView == EmojisCollectionView {
                header.titleLabel.text = "Emoji"
                header.frame.origin.x = CGFloat(-20)
                return header
            } else {
                header.titleLabel.text = "Цвет"
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
        
        if collectionView == EmojisCollectionView {
            selectedEmoji = emojis[indexPath.item]
            cell?.allocationCell(emojiCell: true, allocationColor: .backgroundDay)
        } else {
            selectedColor = colors[indexPath.item]
            cell?.allocationCell(emojiCell: false, allocationColor: selectedColor!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell
        
        if collectionView == EmojisCollectionView {
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

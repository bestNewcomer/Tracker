//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 10.02.2024.
//

import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    let emojis  = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝️","😪"]
    let colors: [UIColor] = [.colorSelection1,.colorSelection2,.colorSelection3,.colorSelection4,.colorSelection5,.colorSelection6,.colorSelection7,.colorSelection8,.colorSelection9,.colorSelection10,.colorSelection11,.colorSelection12,.colorSelection13,.colorSelection14,.colorSelection15,.colorSelection16,.colorSelection17,.colorSelection18]
    let collectionHeader = ["Emoji","Цвет"]
    
    //MARK:  - Private Properties
    private var emojisAndColorsCollectionView: UICollectionView!
    private let params: GeometricParams
    private var selectedSchedule: Schedule?
    
    private let labelTitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Новая привычка")
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
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .backgroundDay
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
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
        return specialView
    }()
    
    private lazy var viewSchedule: SpecialView = {
        let specialView = SpecialView()
        specialView.renamingLabelBasic(nameView: "Расписание")
        //specialView.conditionTap()
        specialView.jump = { [weak self] in
            self?.updateCreatingTrackerViewController()
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
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(CreatingTrackerViewController.self, action: #selector(Self.tapСancelButton), for: .touchUpInside)
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        button.addTarget(CreatingTrackerViewController.self, action: #selector(Self.tabСreateButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init() {
        self.params = GeometricParams(cellCount: 6, leftInset: 6, rightInset: 6, cellSpacing: 17)
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
        settings()
        emojisAndColorsCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.cellID)
        emojisAndColorsCollectionView.register(SpecialSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialSectionHeader.headerID)
    }
    
    // MARK: - Actions
    @objc
    private func tapСancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func tabСreateButton(){
        print("Кнопка создания работает")
    }
    
    //MARK:  - Public Methods
    func updateCreatingTrackerViewController() {
        let schedule = ScheduleViewController()
        schedule.onScheduleUpdated = { [weak self] updatedSchedule in
            self?.selectedSchedule = updatedSchedule
            let formattedSchedule = updatedSchedule.scheduleText
            self?.viewSchedule.renamingLabelBasic(nameView: "Расписание")
            self?.viewSchedule.renamingLabelSecondary(surnameView: formattedSchedule)
        }

        schedule.modalPresentationStyle = .pageSheet
        present(schedule, animated: true)
    }
    
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        emojisAndColorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojisAndColorsCollectionView.dataSource = self
        emojisAndColorsCollectionView.delegate = self
        emojisAndColorsCollectionView.isScrollEnabled = false
    }
    private func settings() {
        view.addSubview(scrollView)
        view.addSubview(labelTitle)
        scrollView.addSubview(contentView)
        contentView.addSubview(textField)
        contentView.addSubview(stackView)
        view.addSubview(emojisAndColorsCollectionView)
        contentView.addSubview(lowerStackView)
        stackView.addArrangedSubview(viewCategories.view)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(viewSchedule.view)
        lowerStackView.addArrangedSubview(cancelButton)
        lowerStackView.addArrangedSubview(createButton)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        emojisAndColorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 87),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            
            emojisAndColorsCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            emojisAndColorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojisAndColorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            emojisAndColorsCollectionView.heightAnchor.constraint(equalToConstant: 460),
            
            lowerStackView.topAnchor.constraint(equalTo: emojisAndColorsCollectionView.bottomAnchor, constant: 16),
            lowerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lowerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            lowerStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func settingsRestrictions() {
        scrollView.addSubview(labelRestrictions)
        
        labelRestrictions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelRestrictions.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            labelRestrictions.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelRestrictions.heightAnchor.constraint(equalToConstant: 22),
            
            stackView.topAnchor.constraint(equalTo: labelRestrictions.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func deleteLabelRestrictions() {
        labelRestrictions.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
}

// MARK: - UITextFieldDelegate
extension CreatingTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            let currentLength = textField.text?.count ?? 0
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
    
    func numberOfSections(in: UICollectionView) -> Int {
        return collectionHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCell.cellID, for: indexPath) as? EmojiAndColorCell else { fatalError("Failed to cast UICollectionViewCell to TrackersCell") }
        if indexPath.section == 0 {
            cell.customizeCell(emojiCell: emojis[indexPath.row], colorCell: nil)
        } else {
            cell.customizeCell(emojiCell: "", colorCell: colors[indexPath.row])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CreatingTrackerViewController: UICollectionViewDelegate {
    //настройка "Заголовка"
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = emojisAndColorsCollectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: SpecialSectionHeader.headerID,for: indexPath) as? SpecialSectionHeader
            else { fatalError("Failed to cast UICollectionReusableView to TrackersHeader") }
            
            header.titleLabel.text = collectionHeader[indexPath.section]
            header.frame.origin.x = CGFloat(-20)
            return header
        default:
            fatalError("Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreatingTrackerViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = emojisAndColorsCollectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    // расстояние между ячейками по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
    // расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(params.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 2, section: section)
        let headerView = self.collectionView(emojisAndColorsCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: emojisAndColorsCollectionView.frame.width,height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
    }
    
}

////
////  CreatingTrackerViewController.swift
////  Tracker
////
////  Created by Ринат Шарафутдинов on 10.02.2024.
////
//
//import UIKit
//
//final class CreatingTrackerViewController: UIViewController {
//    
//    // MARK: - Public Properties
//    let emojis  = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝️","😪"]
//    let colors: [UIColor] = [.colorSelection1,.colorSelection2,.colorSelection3,.colorSelection4,.colorSelection5,.colorSelection6,.colorSelection7,.colorSelection8,.colorSelection9,.colorSelection10,.colorSelection11,.colorSelection12,.colorSelection13,.colorSelection14,.colorSelection15,.colorSelection16,.colorSelection17,.colorSelection18]
//    let collectionHeader = ["Emoji","Цвет"]
//    
//    //MARK:  - Private Properties
//    private var emojisCollectionView: UICollectionView!
//    
//    
//    private let params: GeometricParams
//    
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .green
//        scrollView.alwaysBounceVertical = true
//        scrollView.contentInsetAdjustmentBehavior = .never
//        return scrollView
//    }()
//    
//    private let labelTitle: SpecialHeader = {
//        let label = SpecialHeader()
//        label.customizeHeader(nameHeader: "Новая привычка")
//        return label
//    }()
//    private lazy var textField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Введите название трекера"
//        textField.layer.cornerRadius = 16
//        textField.backgroundColor = .backgroundDay
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
//        textField.leftViewMode = .always
//        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        textField.delegate = self
//        textField.resignFirstResponder()
//        return textField
//    }()
//    
//    private let labelRestrictions: UILabel = {
//        let label = UILabel()
//        label.text = "Ограничение 38 символов"
//        label.textColor = .ypRed
//        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        return label
//    }()
//    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillProportionally
//        stackView.backgroundColor = .backgroundDay
//        stackView.layer.cornerRadius = 16
//        return stackView
//    }()
//    
//    private lazy var ViewCategories: SpecialView = {
//        let specialView = SpecialView()
//        specialView.customizeView(nameView: "Категория", surnameView: nil) // добавить вместо nil входные данные
//        return specialView
//    }()
//    
//    private lazy var ViewSchedule: SpecialView = {
//        let specialView = SpecialView()
//        specialView.customizeView(nameView: "Расписание", surnameView: nil) // добавить вместо nil входные данные
//        specialView.conditionTap()
//        specialView.jump = ScheduleViewController()
//        
//        return specialView
//    }()
//    
//    private lazy var divider: Divider = {
//        let view = Divider()
//        return view
//    }()
//    
//    private lazy var lowerStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 8
//        return stackView
//    }()
//    
//    private let cancelButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Отменить", for: .normal)
//        button.setTitleColor(.ypRed, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        button.layer.cornerRadius = 16
//        button.layer.borderColor = UIColor.ypRed.cgColor
//        button.layer.borderWidth = 1
//        button.addTarget(self, action: #selector(Self.tapСancelButton), for: .touchUpInside)
//        return button
//    }()
//    
//    private let createButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Создать", for: .normal)
//        button.setTitleColor(.ypWhiteDay, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        button.layer.cornerRadius = 16
//        button.backgroundColor = .ypGray
//        button.addTarget(self, action: #selector(Self.tabСreateButton), for: .touchUpInside)
//        return button
//    }()
//    
//    // MARK: - Initialization
//    
//    init() {
//        self.params = GeometricParams(cellCount: 6, leftInset: 6, rightInset: 6, cellSpacing: 17)
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK:  - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .ypWhiteDay
//        
//        subSettingsCollectionsView()
//        settings()
//        emojisCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.cellID)
//        emojisCollectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.headerID)
//    }
//    
//    // MARK: - Actions
//    @objc
//    private func tapСancelButton(){
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc
//    private func tabСreateButton(){
//        print("Кнопка создания работает")
//    }
//    
//    //MARK:  - Private Methods
//    private func subSettingsCollectionsView() {
//        emojisCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        emojisCollectionView.dataSource = self
//        emojisCollectionView.delegate = self
//        emojisCollectionView.backgroundColor = .red
//        emojisCollectionView.isScrollEnabled = false
//    }
//    private func settings() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(labelTitle)
//        scrollView.addSubview(textField)
//        scrollView.addSubview(stackView)
//        view.addSubview(emojisCollectionView)
//        scrollView.addSubview(lowerStackView)
//        stackView.addArrangedSubview(ViewCategories.view)
//        stackView.addArrangedSubview(divider)
//        stackView.addArrangedSubview(ViewSchedule.view)
//        lowerStackView.addArrangedSubview(cancelButton)
//        lowerStackView.addArrangedSubview(createButton)
//        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        labelTitle.translatesAutoresizingMaskIntoConstraints = false
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        emojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            scrollView.heightAnchor.constraint(equalToConstant: 937),
//            
//            labelTitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            labelTitle.heightAnchor.constraint(equalToConstant: 22),
//            
//            textField.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 43),
//            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            textField.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            textField.heightAnchor.constraint(equalToConstant: 75),
//            
//            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: 150),
//            
//            emojisCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
//            emojisCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 2),
//            emojisCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -2),
//            emojisCollectionView.heightAnchor.constraint(equalToConstant: 460),
//            
//            lowerStackView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 16),
//            lowerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            lowerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            lowerStackView.heightAnchor.constraint(equalToConstant: 60),
//        ])
//    }
//    
//    private func settingsRestrictions() {
//        
//        scrollView.addSubview(labelRestrictions)
//        
//        labelRestrictions.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            labelRestrictions.topAnchor.constraint(equalTo: textField.topAnchor, constant: 83),
//            labelRestrictions.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            labelRestrictions.heightAnchor.constraint(equalToConstant: 22),
//            
//            //stackView.topAnchor.constraint(equalTo: labelRestrictions.bottomAnchor, constant: 24),
//        ])
//    }
//    
//}
//
//// MARK: - UITextFieldDelegate
//extension CreatingTrackerViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == self.textField {
//            let currentLength = textField.text?.count ?? 0
//            if currentLength + string.count > 38 {
//                //settingsRestrictions() поправить констрейнты и включить уведомление о превышении 38 символов
//                return false
//            }
//        }
//        return true
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension CreatingTrackerViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return emojis.count
//    }
//    
//    func numberOfSections(in: UICollectionView) -> Int {
//        return collectionHeader.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCell.cellID, for: indexPath) as? EmojiAndColorCell else { fatalError("Failed to cast UICollectionViewCell to TrackersCell") }
//        if indexPath.section == 0 {
//            cell.customizeCell(emojiCell: emojis[indexPath.row], colorCell: nil)
//        } else {
//            cell.customizeCell(emojiCell: "", colorCell: colors[indexPath.row])
//        }
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//extension CreatingTrackerViewController: UICollectionViewDelegate {
//    //настройка "Заголовка"
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            guard let header = emojisCollectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: TrackerSupplementaryView.headerID,for: indexPath) as? TrackerSupplementaryView
//            else { fatalError("Failed to cast UICollectionReusableView to TrackersHeader") }
//            
//            header.titleLabel.text = collectionHeader[indexPath.section]
//            header.frame.origin.x = CGFloat(-20)
//            return header
//        default:
//            fatalError("Unexpected element kind")
//        }
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//extension CreatingTrackerViewController: UICollectionViewDelegateFlowLayout {
//    //отступы от края коллекции
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.rightInset)
//    }
//    // размеры ячейки
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let availableWidth = emojisCollectionView.frame.width - params.paddingWidth
//        let cellWidth =  availableWidth / CGFloat(params.cellCount)
//        return CGSize(width: cellWidth, height: cellWidth)
//    }
//    // расстояние между ячейками по вертикали
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(12)
//    }
//    // расстояние между ячейками по горизонтали
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(params.cellSpacing)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        let indexPath = IndexPath(row: 2, section: section)
//        let headerView = self.collectionView(emojisCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//        
//        return headerView.systemLayoutSizeFitting(CGSize(width: emojisCollectionView.frame.width,height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
//    }
//    
//}

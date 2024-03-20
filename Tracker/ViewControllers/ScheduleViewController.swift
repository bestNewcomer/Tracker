//
//  Test.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 06.03.2024.
//

import UIKit
import SwiftUI

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
   
    var daysWeek: Set<DaysOfWeek> = []
    var onScheduleUpdated: (([DaysOfWeek]) -> Void)?
    var checkButtonValidation: (() -> Void)?
    //MARK:  - Private Properties
    private var ScheduleCollectionView: UICollectionView!
    private let params: GeometricParams
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "Расписание")
        return label
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(tapReadyButton), for: .touchUpInside)
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
        
        ScheduleCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.cellID)
    }
    
    // MARK: - Actions
    @objc private func tapReadyButton(){
        let weekDays = Array(daysWeek)
        onScheduleUpdated?(weekDays)
        checkButtonValidation?()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:  - Private Methods
    private func subSettingsCollectionsView() {
        ScheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        ScheduleCollectionView.dataSource = self
        ScheduleCollectionView.delegate = self
        ScheduleCollectionView.layer.cornerRadius = 16
    }
    
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(ScheduleCollectionView)
        scrollView.addSubview(readyButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        ScheduleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            ScheduleCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            ScheduleCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            ScheduleCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ScheduleCollectionView.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            readyButton.widthAnchor.constraint(equalToConstant: 335),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.cellID, for: indexPath) as? ScheduleCell else { fatalError("Failed to cast UICollectionViewCell to ScheduleCell") }
        cell.renamingLabelBasic(nameView: DaysOfWeek.allCases[indexPath.row].translation, isOn: daysWeek.contains(DaysOfWeek.allCases[indexPath.row]))
        
        if indexPath.row == 0 {
            cell.divider.backgroundColor = .backgroundDay
        }
        
        cell.onSwitchChanged = { [weak self] isOn in
            self?.updateSchedule(forDay: indexPath.row, isOn: isOn)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ScheduleViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    //отступы от края коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: params.leftInset,
                            bottom: 0,
                            right: params.rightInset)
    }
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = ScheduleCollectionView.frame.width - params.paddingWidth
        let availableHeight = ScheduleCollectionView.frame.height
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        let cellHeight = availableHeight / CGFloat(7)
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

extension ScheduleViewController {
    func updateSchedule(forDay dayIndex: Int, isOn: Bool) {
        let day = DaysOfWeek.allCases[dayIndex]
        
        if isOn {
            if !daysWeek.contains(day) {
                daysWeek.insert(day)
                daysWeek.sorted(by: { $0.rawValue < $1.rawValue })
            }
        } else {
            for day in daysWeek {
                if day == day {
                    daysWeek.remove(day)
                    break
                }
            }
        }
        ScheduleCollectionView.reloadItems(at: [IndexPath(row: dayIndex, section: 0)])
    }
}



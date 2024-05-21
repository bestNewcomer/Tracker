//
//  Test.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 06.03.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(activeDays: [DaysOfWeek])
}

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
    var daysWeek: Set<DaysOfWeek> = []
    var checkButtonValidation: (() -> Void)?
    weak var delegate: ScheduleViewControllerDelegate?
    
    //MARK:  - Private Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "schedule_title".localized)
        return label
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ScheduleCell.self,
            forCellReuseIdentifier: ScheduleCell.cellID
        )
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("schedule_ready_button".localized, for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(tapReadyButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(daysWeek: [DaysOfWeek]) {
        super.init(nibName: nil, bundle: nil)
        self.daysWeek = Set(daysWeek)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        settingsConstraints()
    }
    
    // MARK: - Actions
    @objc private func tapReadyButton(){
        let days = Array(daysWeek).sorted { (day1, day2) -> Bool in
            guard let weekday1 = DaysOfWeek.allCases.firstIndex(of: day1),
                  let weekday2 = DaysOfWeek.allCases.firstIndex(of: day2) else { return false }
            return weekday1 < weekday2
        }
        delegate?.didSelectSchedule(activeDays: days)
        checkButtonValidation?()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:  - Private Methods
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(scheduleTableView)
        scrollView.addSubview(readyButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            scheduleTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            scheduleTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scheduleTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            readyButton.widthAnchor.constraint(equalToConstant: 335),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.cellID,for: indexPath) as? ScheduleCell else {fatalError("Could not cast to CategoryCell")}
        let day = DaysOfWeek.allCases[indexPath.row]
        cell.config(with: day, nameView: day.translation, isOn: daysWeek.contains(day))
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorInset: CGFloat = 16
        let separatorWidth = tableView.bounds.width - separatorInset * 2
        let separatorHeight: CGFloat = 1.0
        let separatorX = separatorInset
        let separatorY = cell.frame.height - separatorHeight
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        if !isLastCell {
            let separatorView = UIView(frame: CGRect(x: separatorX, y: separatorY, width: separatorWidth, height: separatorHeight))
            separatorView.backgroundColor = .ypGray
            cell.addSubview(separatorView)
        }
    }
}

// MARK: - ScheduleCellDelegate
extension ScheduleViewController: ScheduleCellDelegate {
    func didTapSwitch(days: DaysOfWeek, active: Bool) {
        if active {
            daysWeek.insert(days)
        } else {
            daysWeek.remove(days)
        }
    }
}



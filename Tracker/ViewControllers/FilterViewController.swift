//
//  FilterViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 15.03.2024.
//

import Foundation
import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func filterSelected(filter: Filter)}

final class FilterViewController: UIViewController {
    
    // MARK: - Public Properties
    var selectedFilter: Filter?
    weak var delegate: FilterViewControllerDelegate?
    
    //MARK:  - Private Properties
    private lazy var filters: [Filter] = Filter.allCases
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "filter_title".localized)
        return label
    }()
    
    private lazy var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.cellID)
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization
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
        filterTableView.reloadData()
        settingsConstraints()
    }
    
    //MARK:  - Private Methods
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(filterTableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        filterTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            filterTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            filterTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            filterTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            filterTableView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellID) as? CategoryCell else { fatalError("Could not cast to CategoryCell") }
        let filter = filters[indexPath.row]
        let active = filter == selectedFilter
        cell.config(nameView: filter.rawValue, isActive: active)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            let active = true
            cell.configImage(isActive: active)
            
            let filter = filters[indexPath.row]
            delegate?.filterSelected(filter: filter)
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else {
            fatalError("Could not cast to FiltersCell")
        }
        let active = true
        cell.configImage(isActive: active)
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

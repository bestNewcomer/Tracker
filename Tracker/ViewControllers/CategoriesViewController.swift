//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 12.03.2024.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - Public Properties
    var checkButtonValidation: (() -> Void)?
    
    //MARK:  - Private Properties
    private var viewModel: CategoriesViewModel
    
    private lazy var  stubImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "imageTrackerStub"))
        return image
    }()
    
    private lazy var  stubLabel: UILabel = {
        let label = UILabel()
        label.text = "category_placeholder".localized
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        return scrollView
    }()
    
    private lazy var labeltitle: SpecialHeader = {
        let label = SpecialHeader()
        label.customizeHeader(nameHeader: "category_title".localized)
        return label
    }()
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CategoryCell.self,
            forCellReuseIdentifier: CategoryCell.cellID
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
    
    private lazy var addCategory: UIButton = {
        let button = UIButton()
        button.setTitle("category_add_button".localized, for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(tapAddCategory), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(
        delegate: CategoriesViewModelDelegate?,
        selectedCategories: TrackerCategory?
    ) {
        viewModel = CategoriesViewModel(
            selectedCategories: selectedCategories,
            delegate: delegate
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
      
        viewModel.updateClosure = { [weak self] in
            print("Update closure called")
            guard let self else { return }
            self.categoriesTableView.reloadData()
            self.updateNotFoundedCategories()
        }
        settingsConstraints()
        trackerStub()
    }
    
    // MARK: - Actions
    @objc private func tapAddCategory(){
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        newCategoryViewController.modalPresentationStyle = .pageSheet
        present(newCategoryViewController, animated: true)
    }
    
    //MARK:  - Public Methods
    func updateNotFoundedCategories()  {
        categoriesTableView.isHidden = viewModel.isTableViewHidden
        stubImage.isHidden = !viewModel.isTableViewHidden
        stubLabel.isHidden = !viewModel.isTableViewHidden
    }
    
    //MARK:  - Private Methods
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
    
    private func settingsConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(labeltitle)
        scrollView.addSubview(categoriesTableView)
        scrollView.addSubview(addCategory)
        
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labeltitle.translatesAutoresizingMaskIntoConstraints = false
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        addCategory.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            labeltitle.topAnchor.constraint(equalTo: scrollView.topAnchor),
            labeltitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labeltitle.heightAnchor.constraint(equalToConstant: 22),
            
            categoriesTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 87),
            categoriesTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            categoriesTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategory.topAnchor, constant: -16),
            
            addCategory.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategory.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addCategory.widthAnchor.constraint(equalToConstant: 335),
            addCategory.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.categories.count
        updateNotFoundedCategories()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellID,for: indexPath) as? CategoryCell else {fatalError("Could not cast to CategoryCell")}
        let category = viewModel.categories[indexPath.row]
//        let active = viewModel.selectedCategories == category
        cell.config(nameView: category.title, isActive: true)
        
        if indexPath.row == viewModel.categories.count - 1 {
            cell.contentView.clipsToBounds = true
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [
                .layerMaxXMaxYCorner,
                .layerMinXMaxYCorner
            ]
        } else if indexPath.row == 0 {
            cell.contentView.clipsToBounds = true
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner
            ]
        } else {
            cell.contentView.layer.cornerRadius = 0
        }
        
        if viewModel.categories.count == 1 {
            cell.contentView.layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner,
                .layerMaxXMaxYCorner,
                .layerMinXMaxYCorner
            ]
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell  {
            let active = true
            cell.configImage(isActive: active)
            let selectedCategoryTitle = cell.getSelectedCategoryTitle()
            viewModel.selectCategory(with: selectedCategoryTitle)
            checkButtonValidation?()
            tableView.deselectRow(at: indexPath, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
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

// MARK: - NewCategoryViewControllerDelegate
extension CategoriesViewController: NewCategoryViewControllerDelegate {
    func addCategory(_ category: TrackerCategory) {
        viewModel.selectCategory(with: category.title)
        viewModel.selectedCategories(category)
        categoriesTableView.reloadData()
    }
}


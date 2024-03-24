//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 22.03.2024.
//

import Foundation

protocol CategoriesViewModelDelegate: AnyObject {
    func didSelectCategory(category: TrackerCategory)
}

final class CategoriesViewModel {
    var updateClosure: (() -> Void)?

    private(set) var categories = [TrackerCategory]() {
        didSet {
            updateClosure?()
        }
    }

    var isTableViewHidden: Bool {
        return categories.isEmpty
    }

    private(set) var selectedCategories: TrackerCategory?
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private weak var delegate: CategoriesViewModelDelegate?

    // MARK: - Lifecycle
    init(
        selectedCategories: TrackerCategory?,
        delegate: CategoriesViewModelDelegate?
    ) {
        self.selectedCategories = selectedCategories
        self.delegate = delegate

        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
    }

    func selectCategory(with title: String) {
        let category = TrackerCategory(title: title, trackersArray: [])
        delegate?.didSelectCategory(category: category)
    }

    func selectedCategories(_ category: TrackerCategory) {
        selectedCategories = category
        delegate?.didSelectCategory(category: category)
        updateClosure?()
    }

    func deleteCategory(_ category: TrackerCategory) {
        try? self.trackerCategoryStore.deleteCategory(category)
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        print("Categories updated")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.categories = trackerCategoryStore.trackerCategories
        }
    }
}


//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Ринат Шарафутдинов on 08.01.2024.
//

import UIKit

protocol StatisticsViewControllerDelegate: AnyObject {
    func updateStatistics()
}

final class StatisticsViewController: UIViewController {
    //MARK: - Public Properties
    weak var delegate: StatisticsViewControllerDelegate?
    
    //MARK: - Private Properties
    private let trackerRecordStore = TrackerRecordStore()
    private var completedTracker: [TrackerRecord] = []
    
    private lazy var stabImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "imageStatisticsStub"))
        return image
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "statistics_placeholder".localized
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlackDay")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlackDay")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    //MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        navBarStatistics()
        statisticsConstraints()
        trackerRecordStore.delegate = self
        updateTrackerRecords()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        container.addGradienBorder(
            colors: [
                UIColor(named: "YP Red") ?? .red,
                UIColor(named: "YP Green") ?? .green,
                UIColor(named: "YP Light Blue") ?? .blue
            ],
            width: 3
        )
    }
    
    //MARK:  - Private Methods
    private func navBarStatistics () {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "statistics_title".localized
    }
    
    private func statisticsConstraints () {
        view.addSubview(stabImage)
        view.addSubview(stubLabel)
        view.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        stabImage.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stabImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stabImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stabImage.widthAnchor.constraint(equalToConstant: 80),
            
            stabImage.heightAnchor.constraint(equalToConstant: 80),
            stubLabel.topAnchor.constraint(equalTo: stabImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
//        
//        stabImage.isHidden = true
//        stubLabel.isHidden = true
    }
    
    func updateTrackerRecords() {
        completedTracker = trackerRecordStore.trackerRecords
        titleLabel.text = "\(completedTracker.count)"
        subtitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("statistics_trackersCompleted".localized, comment: "число дней"), completedTracker.count)
        stabImage.isHidden = completedTracker.count > 0
        stubLabel.isHidden = completedTracker.count > 0
        container.isHidden = completedTracker.count == 0
        delegate?.updateStatistics()
        trackerRecordStore.reload()
        updateStatistics()
    }
}

// MARK: - StatisticsViewControllerDelegate
extension StatisticsViewController: StatisticsViewControllerDelegate {
    func updateStatistics() {
        DispatchQueue.main.async{
            self.updateTrackerRecords()
        }
    }
}

// MARK: - TrackerRecordStoreDelegate
extension StatisticsViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        DispatchQueue.main.async{
            self.updateTrackerRecords()
        }
    }
}

extension UIView {
    private static let GradientBorder = "GradientBorderLayer"

    func addGradienBorder(
        colors: [UIColor],
        width: CGFloat,
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5)
    ) {
        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? CAGradientLayer()
        border.frame = bounds
        border.colors = colors.map { $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint

        let mask = CAShapeLayer()
        mask.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 16
        ).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width

        border.mask = mask

        let isAlreadyAdded = existingBorder != nil
        if !isAlreadyAdded {
            layer.addSublayer(border)
        }
    }

    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter {
            $0.name == UIView.GradientBorder
        }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }

    func removeGradientBorder() {
        self.gradientBorderLayer()?.removeFromSuperlayer()
    }
}

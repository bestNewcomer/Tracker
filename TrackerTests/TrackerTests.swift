//
//  AlpabetTests.swift
//  AlpabetTests
//
//  Created by Ринат Шарафутдинов on 28.03.2024.
//
import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testTrackersViewControllerLightMode() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    func testTrackersViewControllerDarkMode() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}


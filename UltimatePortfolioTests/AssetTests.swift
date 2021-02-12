//
//  AssetTests.swift
//  UltimatePortfolioTests
//
//  Created by Sergio Rodríguez Rama on 12/2/21.
//

import XCTest

@testable import UltimatePortfolio

class AssetTests: BaseTestCase {
    func testColorsExists() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    func testJsonLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty)
    }
}

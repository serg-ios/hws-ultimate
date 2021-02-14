//
//  PerformanceTest.swift
//  UltimatePortfolioTests
//
//  Created by Sergio Rodríguez Rama on 14/2/21.
//

import XCTest

@testable import UltimatePortfolio

class PerformanceTest: BaseTestCase {
    func testAwardCalculationPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }
        // Simulate a lot of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(
            awards.count,
            500,
            "This verifies the number of awards is constant, modify this if you need more awards."
        )
        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}

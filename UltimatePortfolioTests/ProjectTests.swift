//
//  ProjectTests.swift
//  UltimatePortfolioTests
//
//  Created by Sergio Rodríguez Rama on 12/2/21.
//

import XCTest
import CoreData

@testable import UltimatePortfolio

class ProjectTests: BaseTestCase {
    func testCreatingProjectAndItems() {
        let targetCount = 10
        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)
            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeleteItems() throws {
        try dataController.createSampleData()
        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)
        dataController.delete(projects[0])
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
    }
}

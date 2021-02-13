//
//  BaseTestCase.swift
//  UltimatePortfolioTests
//
//  Created by Sergio Rodríguez Rama on 12/2/21.
//

import CoreData
import XCTest

@testable import UltimatePortfolio

class BaseTestCase: XCTestCase {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}

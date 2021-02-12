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

    var dataControler: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataControler = DataController(inMemory: true)
        managedObjectContext = dataControler.container.viewContext
    }
}

//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Sergio Rodríguez Rama on 14/2/21.
//

import SwiftUI
import XCTest

@testable import UltimatePortfolio

class ExtensionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let items = [5, 3, 1, 2, 4]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
    }

    func testSequenceKeypathSortingCustom() {
        struct Example: Equatable { // swiftlint:disable:this nesting
            let value: String
        }
        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        let array = [example1, example2, example3]

        let sortedItems = array.sorted(by: \.value) { $0 > $1 }
        XCTAssertEqual(sortedItems, [example3, example2, example1])
    }

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode a non-empty array.")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(
            data,
            "The rain in Spain falls mainly on the Spaniards.",
            "The string must match the content of DecodableString.json"
        )
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let dictionary = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(
            dictionary,
            ["One": 1, "Three": 3, "Two": 2],
            "The dictionary must match the content of DecodableDictionary.json"
        )
    }

    func testBindingOnChange() {
        // Given
        var storedValue = ""
        var onChangeFunctionRun = false

        func exampleFunctionToRun() {
            onChangeFunctionRun = true
        }

        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )
        let changedBinding = binding.onChange(exampleFunctionToRun)

        // When
        changedBinding.wrappedValue = "Test"

        // Then
        XCTAssertTrue(onChangeFunctionRun)
    }
}

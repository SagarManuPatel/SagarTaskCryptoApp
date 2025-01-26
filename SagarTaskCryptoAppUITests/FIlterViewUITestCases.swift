//
//  FIlterViewUITestCases.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 26/01/25.
//

import XCTest


class FilterViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Continue after failure
        continueAfterFailure = false
        
        // Launch the application
        app.launch()
    }

    func testFilterButtonsExist() {
        // Verify all filter buttons exist
        let activeButton = app.buttons["Active Coins"]
        let inactiveButton = app.buttons["Inactive Coins"]
        let onlyTokensButton = app.buttons["Only Tokens"]
        let onlyCoinsButton = app.buttons["Only Coins"]
        let newCoinsButton = app.buttons["New Coins"]

        XCTAssertTrue(activeButton.exists, "Active Coins button should exist")
        XCTAssertTrue(inactiveButton.exists, "Inactive Coins button should exist")
        XCTAssertTrue(onlyTokensButton.exists, "Only Tokens button should exist")
        XCTAssertTrue(onlyCoinsButton.exists, "Only Coins button should exist")
        XCTAssertTrue(newCoinsButton.exists, "New Coins button should exist")
    }

    func testButtonToggleState() {
        // Test toggling buttons
        let activeButton = app.buttons["Active Coins"]

        // Initial state: not selected
        XCTAssertFalse(activeButton.isSelected, "Active Coins button should not be selected by default")
        
        // Tap button to select it
        activeButton.tap()
        XCTAssertTrue(activeButton.isSelected, "Active Coins button should be selected after tapping")
        
        // Tap button again to deselect
        activeButton.tap()
        XCTAssertFalse(activeButton.isSelected, "Active Coins button should not be selected after second tap")
    }

    func testFilterInteraction() {
        // Test multiple filter toggles
        let activeButton = app.buttons["Active Coins"]
        let newCoinsButton = app.buttons["New Coins"]

        // Select Active Coins and New Coins
        activeButton.tap()
        newCoinsButton.tap()
        
        XCTAssertTrue(activeButton.isSelected, "Active Coins button should be selected")
        XCTAssertTrue(newCoinsButton.isSelected, "New Coins button should be selected")
        
        // Deselect Active Coins
        activeButton.tap()
        XCTAssertFalse(activeButton.isSelected, "Active Coins button should not be selected")
        XCTAssertTrue(newCoinsButton.isSelected, "New Coins button should remain selected")
    }


    func testOnlyOneTypeFilterActive() {
        // Test mutually exclusive type filters (Only Tokens and Only Coins)
        let onlyTokensButton = app.buttons["Only Tokens"]
        let onlyCoinsButton = app.buttons["Only Coins"]

        // Select Only Tokens
        onlyTokensButton.tap()
        XCTAssertTrue(onlyTokensButton.isSelected, "Only Tokens button should be selected")
        XCTAssertFalse(onlyCoinsButton.isSelected, "Only Coins button should not be selected")
        
        // Select Only Coins (should deselect Only Tokens)
        onlyCoinsButton.tap()
        XCTAssertTrue(onlyCoinsButton.isSelected, "Only Coins button should be selected")
        XCTAssertFalse(onlyTokensButton.isSelected, "Only Tokens button should not be selected")
    }
}

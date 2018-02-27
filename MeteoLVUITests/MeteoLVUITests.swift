//
//  MeteoLVUITests.swift
//  MeteoLVUITests
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import XCTest

class MeteoLVUITests: XCTestCase {
  
  /// Screenshot counter
  var counter = 0
  
  let observationName = "Rūjiena"
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false
  }
  
  override func tearDown() {
    
    super.tearDown()
  }
  
  func testAppRun() {
    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()
  
    let predicate = NSPredicate(format: "label BEGINSWITH '\(observationName)'")
    let annotation = app.otherElements.matching(predicate).element(boundBy: 0)
    
    XCTAssertTrue(waitForElementToAppear(annotation, timeout: 10))
    
    takeScreenShot("Observations")
    
    annotation.tap()
    
    let moreInfoButton = app.buttons["More Info"]
    XCTAssertTrue(waitForElementToAppear(moreInfoButton))
    
    takeScreenShot("Tap_Observation")
    
    moreInfoButton.tap()
    
    let navigationBar = app.navigationBars[observationName]
    XCTAssertTrue(waitForElementToAppear(navigationBar))
    
    takeScreenShot("Observation_Data")
    
    let parametersTable = app.tables.firstMatch
    let temperatureCell = parametersTable.cells.staticTexts["Temperatūra (°C)"]
    let windSpeedCell = parametersTable.cells.staticTexts["Vēja ātrums (m/s)"]
    let windDirectionCell = parametersTable.cells.staticTexts["Vēja virziens"]
    
    XCTAssertTrue(waitForElementToAppear(temperatureCell))
    XCTAssertTrue(waitForElementToAppear(windSpeedCell))
    XCTAssertTrue(waitForElementToAppear(windDirectionCell))
    
    let backButton = navigationBar.buttons["Novērojumi"].firstMatch
    backButton.tap()
    
    let observationsNavigationbar = app.navigationBars["Novērojumi"].firstMatch
    XCTAssertTrue(waitForElementToAppear(observationsNavigationbar))
    
    let refreshButton = observationsNavigationbar.buttons["Refresh"]
    XCTAssertTrue(waitForElementToAppear(refreshButton))
    refreshButton.tap()
  }
  
  fileprivate func takeScreenShot(_ name: String) {
    snapshot("\(String(format: "%02d", counter))_\(name)")
    counter += 1
  }
}

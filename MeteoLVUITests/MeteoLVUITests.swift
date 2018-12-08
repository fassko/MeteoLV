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
  let app = XCUIApplication()
  
  override func setUp() {
    super.setUp()
    
    setupSnapshot(app)
    
    continueAfterFailure = false
  }
  
  func testMeteoLVStation() {
    
    let stationName = "Rūjiena"
    
    app.launchArguments.append(contentsOf: [
      "-meteoLVStation"
    ])
    launchApp()
    
    let navigationBar = app.navigationBars[stationName]
    XCTAssertTrue(waitForElementToAppear(navigationBar))

    let parametersTable = app.tables.firstMatch
    let temperatureLabel = parametersTable.cells.staticTexts["Temperatūra (°C)"]
    let temperatureValue = parametersTable.cells.staticTexts["+ 0,6"]
    
    let windSpeedCell = parametersTable.cells.staticTexts["Vēja ātrums (m/s)"]
    let windSpeedValue = parametersTable.cells.staticTexts["ZA"]
    
    let windDirectionCell = parametersTable.cells.staticTexts["Vēja virziens"]
    let windDirectionValue = parametersTable.cells.staticTexts["3/5"]
    
    let humidityCell = parametersTable.cells.staticTexts["Mitrums (%)"]
    let humidityValue = parametersTable.cells.staticTexts["90"]
    
    let airPressureCell = parametersTable.cells.staticTexts["Spiediens (mm Hg)"]
    let airPressureValue = parametersTable.cells.staticTexts["768,2"]
    
    let snowCell = parametersTable.cells.staticTexts["Sniegs (cm)"]
    let snowValue = parametersTable.cells.staticTexts["0"]
    
    let visibilityCell = parametersTable.cells.staticTexts["Redzamība (m)"]
    let visibilityValue = parametersTable.cells.staticTexts["20000"]
    
    XCTAssertTrue(temperatureLabel.waitForExistence(timeout: 1))
    XCTAssertTrue(temperatureValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(windSpeedCell.waitForExistence(timeout: 1))
    XCTAssertTrue(windSpeedValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(windDirectionCell.waitForExistence(timeout: 1))
    XCTAssertTrue(windDirectionValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(humidityCell.waitForExistence(timeout: 1))
    XCTAssertTrue(humidityValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(airPressureCell.waitForExistence(timeout: 1))
    XCTAssertTrue(airPressureValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(snowCell.waitForExistence(timeout: 1))
    XCTAssertTrue(snowValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(visibilityCell.waitForExistence(timeout: 1))
    XCTAssertTrue(visibilityValue.waitForExistence(timeout: 1))
    
    takeScreenShot("Observation_Data_\(stationName)")

    let backButton = navigationBar.buttons["Novērojumi"].firstMatch
    backButton.tap()
  }
  
  func testLVRoadStation() {
    app.launchArguments.append(contentsOf: [
      "-lvRoadStation"
      ])
    launchApp()
    
    let parametersTable = app.tables.firstMatch
    let gaissCell = parametersTable.cells.staticTexts["Gaiss"]
    let virsmaCell = parametersTable.cells.staticTexts["Virsma"]
    let mitrumsCell = parametersTable.cells.staticTexts["Mitrums"]
    let vejsCell = parametersTable.cells.staticTexts["Vējš"]
    
    XCTAssertTrue(gaissCell.waitForExistence(timeout: 1))
    XCTAssertTrue(virsmaCell.waitForExistence(timeout: 1))
    XCTAssertTrue(mitrumsCell.waitForExistence(timeout: 1))
    XCTAssertTrue(vejsCell.waitForExistence(timeout: 1))
  }
  
  func testAppRun() {
    launchApp()
    
    takeScreenShot("MainScreen")

    let observationsNavigationbar = app.navigationBars["Novērojumi"].firstMatch
    XCTAssertTrue(waitForElementToAppear(observationsNavigationbar))

    let refreshButton = observationsNavigationbar.buttons["Refresh"]
    XCTAssertTrue(waitForElementToAppear(refreshButton))

    refreshButton.tap()

    sleep(3)

    takeScreenShot("RefreshedMainScreen")
  }
  
  func testInfoView() {
    launchApp()
    
    app.navigationBars["Novērojumi"].buttons["Info"].tap()
    
    let navigationBar = app.navigationBars["Info"]
    XCTAssertTrue(waitForElementToAppear(navigationBar))

    XCTAssertTrue(app.images["Logo"].exists)
    XCTAssertTrue(app.textViews["Description"].exists)
    
    takeScreenShot("InfoScreen")
    
    let backButton = navigationBar.buttons["Novērojumi"].firstMatch
    backButton.tap()
  }
  
  func testTapMeteoLV() {
    launchApp()
    
    runWithStation("Rūjiena")
  }
  
  func testTapLVRoad() {
    launchApp()
    runWithStation("Strenči")
  }
  
  private func launchApp() {
    app.launch()
    
    sleep(5)
  }
  
  private func runWithStation(_ stationName: String) {
    
    let predicate = NSPredicate(format: "label BEGINSWITH '\(stationName)'")
    let annotation = app.otherElements.matching(predicate).element(boundBy: 0)
    
    annotation.tap()
    
    XCTAssertTrue(annotation.waitForExistence(timeout: 1))
    
    takeScreenShot("Observation_Data_\(stationName)")
  }
  
  fileprivate func takeScreenShot(_ name: String) {
    snapshot("\(String(format: "%02d", counter))_\(name)")
    counter += 1
  }
}

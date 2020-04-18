//
//  MeteoLVUITests.swift
//  MeteoLVUITests
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import XCTest

class MeteoLVUITests: XCTestCase {
  
  let app = XCUIApplication()
  
  override func setUp() {
    super.setUp()
    
    setupSnapshot(app)
    
    continueAfterFailure = false
  }
  
  func testList() {
    launchApp()
    
    app.tabBars.buttons["List"].tap()
    sleep(2)
    
    takeScreenShot("list", counter: 6)
    
    let table = app.tables.firstMatch
    let lastCell = table.cells.element(boundBy: table.cells.count-1)
    table.scrollToElement(element: lastCell)
    
    lastCell.tap()
  }
  
  func testFavorites() {
    launchApp()
    
    app.tabBars.buttons["Favorites"].tap()
    sleep(2)
    
    takeScreenShot("favorites", counter: 6)
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
    let temperatureValue = parametersTable.cells.staticTexts["+0,6"]
    
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
    
    takeScreenShot("meteo_lv_station_\(stationName)", counter: 4)

    let backButton = navigationBar.buttons["Map"].firstMatch
    backButton.tap()
  }
  
  func testLVRoadStation() {
    app.launchArguments.append(contentsOf: [
      "-lvRoadStation"
      ])
    launchApp()
    
    let stationName = "Strenči"
    let navigationBar = app.navigationBars[stationName]
    
    let parametersTable = app.tables.firstMatch
    
    let gaissCell = parametersTable.cells.staticTexts["Gaiss"]
    let gaissValue = parametersTable.cells.staticTexts["-0.8°C"]
    
    let mitrumsCell = parametersTable.cells.staticTexts["Mitrums"]
    let mitrumsValue = parametersTable.cells.staticTexts["100%"]
    
    let vejsCell = parametersTable.cells.staticTexts["Vējš"]
    let vejsValue = parametersTable.cells.staticTexts["0m/s"]
    
    XCTAssertTrue(gaissCell.waitForExistence(timeout: 1))
    XCTAssertTrue(gaissValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(mitrumsCell.waitForExistence(timeout: 1))
    XCTAssertTrue(mitrumsValue.waitForExistence(timeout: 1))
    
    XCTAssertTrue(vejsCell.waitForExistence(timeout: 1))
    XCTAssertTrue(vejsValue.waitForExistence(timeout: 1))
    
    takeScreenShot("LV_road_Station_\(stationName)", counter: 4)
    
    let backButton = navigationBar.buttons["Map"].firstMatch
    backButton.tap()
  }
  
  func testAppRun() {
    launchApp()
    
    takeScreenShot("MainScreen", counter: 1)

    let observationsNavigationbar = app.navigationBars["Map"].firstMatch
    XCTAssertTrue(waitForElementToAppear(observationsNavigationbar))

    let refreshButton = observationsNavigationbar.buttons["Refresh"]
    XCTAssertTrue(waitForElementToAppear(refreshButton))

    refreshButton.tap()

    sleep(3)
  }
  
  func testInfoView() {
    launchApp()
    
    app.tabBars.buttons["Map"].tap()
    
    app.navigationBars["Map"].buttons["Info"].tap()
    
    let navigationBar = app.navigationBars["Info"]
    XCTAssertTrue(waitForElementToAppear(navigationBar))

    XCTAssertTrue(app.images["Logo"].exists)
    XCTAssertTrue(app.textViews["Description"].exists)
    
    takeScreenShot("InfoScreen", counter: 6)
    
    let backButton = navigationBar.buttons["Map"].firstMatch
    backButton.tap()
  }
  
  func testTapMeteoLV() {
    launchApp()
    
    app.tabBars.buttons["Map"].tap()
    
    runWithStation("Rūjiena", counter: 2)
  }
  
  func testTapLVRoad() {
    launchApp()
    
    app.tabBars.buttons["Map"].tap()
    
    runWithStation("Strenči", counter: 3)
  }
  
  private func launchApp() {
    app.launch()
    
    sleep(5)
  }
  
  private func runWithStation(_ stationName: String, counter: Int) {
    
    let predicate = NSPredicate(format: "label BEGINSWITH '\(stationName)'")
    let annotation = app.otherElements.matching(predicate).element(boundBy: 0)
    
    annotation.tap()
    
    XCTAssertTrue(annotation.waitForExistence(timeout: 1))
    
    takeScreenShot("Observation_Data_\(stationName)", counter: counter)
    
  }
  
  fileprivate func takeScreenShot(_ name: String, counter: Int) {
    snapshot("\(String(format: "%02d", counter))_\(name)")
  }
}

extension XCUIElement {
  func scrollToElement(element: XCUIElement) {
    while !element.visible() {
      swipeUp()
    }
  }
  
  func visible() -> Bool {
    guard self.exists && !self.frame.isEmpty else { return false }
    return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
  }
}

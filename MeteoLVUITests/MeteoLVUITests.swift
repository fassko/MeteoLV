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
  let roadObservationName = "Vitrupe"
  
  let app = XCUIApplication()
  
  override func setUp() {
    super.setUp()
    
    setupSnapshot(app)
    app.launch()
    
    continueAfterFailure = false
  }
  
  func testAppRun() {
    
    sleep(3)
    
    takeScreenShot("MainScreen")
   
    runWithStation(observationName)
    runWithStation(roadObservationName)
    
    let observationsNavigationbar = app.navigationBars["Novērojumi"].firstMatch
    XCTAssertTrue(waitForElementToAppear(observationsNavigationbar))
    
    let refreshButton = observationsNavigationbar.buttons["Refresh"]
    XCTAssertTrue(waitForElementToAppear(refreshButton))
    
    refreshButton.tap()
    
    sleep(3)
    
    takeScreenShot("RefreshedMainScreen")
  }
  
  func runWithStation(_ stationName: String) {
    
    let predicate = NSPredicate(format: "label BEGINSWITH '\(stationName)'")
    let annotation = app.otherElements.matching(predicate).element(boundBy: 0)
    
    XCTAssertTrue(waitForElementToAppear(annotation, timeout: 10))
    
    takeScreenShot("station_\(stationName)")
    
    annotation.tap()
    
    let moreInfoButton = app.buttons["More Info"]
    XCTAssertTrue(waitForElementToAppear(moreInfoButton))
    
    takeScreenShot("Tap_Observation_\(stationName)")
    
    moreInfoButton.tap()
    
    let navigationBar = app.navigationBars[stationName]
    XCTAssertTrue(waitForElementToAppear(navigationBar))
    
    takeScreenShot("Observation_Data_\(stationName)")
    
    if stationName == observationName {
      let parametersTable = app.tables.firstMatch
      let temperatureCell = parametersTable.cells.staticTexts["Temperatūra (°C)"]
      let windSpeedCell = parametersTable.cells.staticTexts["Vēja ātrums (m/s)"]
      let windDirectionCell = parametersTable.cells.staticTexts["Vēja virziens"]
    
      XCTAssertTrue(waitForElementToAppear(temperatureCell))
      XCTAssertTrue(waitForElementToAppear(windSpeedCell))
      XCTAssertTrue(waitForElementToAppear(windDirectionCell))
    } else {
      let parametersTable = app.tables.firstMatch
      let gaissCell = parametersTable.cells.staticTexts["Gaiss"]
      let virsmaCell = parametersTable.cells.staticTexts["Virsma"]
      let mitrumsCell = parametersTable.cells.staticTexts["Mitrums"]
      let vejsCell = parametersTable.cells.staticTexts["Vejš"]
      
      XCTAssertTrue(waitForElementToAppear(gaissCell))
      XCTAssertTrue(waitForElementToAppear(virsmaCell))
      XCTAssertTrue(waitForElementToAppear(mitrumsCell))
      XCTAssertTrue(waitForElementToAppear(vejsCell))
    }
    
    let backButton = navigationBar.buttons["Novērojumi"].firstMatch
    backButton.tap()
  }
  
  fileprivate func takeScreenShot(_ name: String) {
    snapshot("\(String(format: "%02d", counter))_\(name)")
    counter += 1
  }
}

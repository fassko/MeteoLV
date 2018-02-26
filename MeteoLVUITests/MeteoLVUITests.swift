//
//  MeteoLVUITests.swift
//  MeteoLVUITests
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import XCTest

class MeteoLVUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false
  }
  
  override func tearDown() {
    
    super.tearDown()
  }
  
  func testLaunch() {
    let app = XCUIApplication()
    app.launch()
    
    sleep(10)
    
    let annotation = app.otherElements.matching(NSPredicate(format: "label BEGINSWITH 'Rūjiena'")).element(boundBy: 0)
    
//    let annotation = app.maps.element.otherElements.matching(NSPredicate(format: "label BEGINSWITH 'Bauska'")).firstMatch
//    annotation.tap()
    annotation.tap()
    sleep(1)
    
    annotation.buttons["More Info"].tap()
    
    sleep(5)
  }
}

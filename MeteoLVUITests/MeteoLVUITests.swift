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
    
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    
    super.tearDown()
  }
  
  func testLaunch() {
    sleep(10)
  }
  
}

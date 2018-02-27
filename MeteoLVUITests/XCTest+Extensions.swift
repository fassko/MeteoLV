//
//  XCTest+Extensions.swift
//  MeteoLVUITests
//
//  Created by Kristaps Grinbergs on 27/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import XCTest

extension XCTestCase {

  @discardableResult
  func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
    let predicate = NSPredicate(format: "exists == true")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
    let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
    return result == .completed
  }
}

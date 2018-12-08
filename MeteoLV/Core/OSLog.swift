//
//  OSLog.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 08/12/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation

import os.log

extension OSLog {
  private static var subsystem = Bundle.main.bundleIdentifier!
  
  static let standard = OSLog(subsystem: subsystem, category: "standard")
}

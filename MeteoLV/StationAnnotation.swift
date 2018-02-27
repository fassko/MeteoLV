//
//  StationAnnotation.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation
import MapKit

import MeteoLVProvider

/// Station annoation
class StationAnnotation: MKPointAnnotation, UIAccessibilityIdentification {
  
  /// Accesibility identifier
  var accessibilityIdentifier: String?
  
  /// Observation station
  let station: Station
  
  init(station: Station) {
    self.station = station
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

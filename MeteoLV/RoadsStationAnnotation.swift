//
//  RoadsStationAnnotation.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 17/03/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation

import MapKit

import MeteoLVProvider

/// Station annoation
class RoadsStationAnnotation: MKPointAnnotation, UIAccessibilityIdentification {
  
  /// Accesibility identifier
  var accessibilityIdentifier: String?
  
  /// Observation station
  let station: LatvianRoadsStation
  
  init(station: LatvianRoadsStation) {
    self.station = station
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

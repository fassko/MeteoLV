//
//  ObservationsStation.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/03/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation

import MeteoLVProvider

/// Observation station
enum ObservationStation {
  
  /// meteo.lv station
  case meteo(Station)
  
  /// lvceli.lv station
  case road(LatvianRoadsStation)
  
  /// Name of the station
  var name: String {
    switch self {
    case let .meteo(meteoStation):
      return meteoStation.name
    case let .road(roadStation):
      return roadStation.name
    }
  }
  
  /// Weather parameters
  var parameters: [[String: String]] {
    switch self {
    case let .meteo(meteoStation):
      
      guard let meteoStationParams = meteoStation.parameters else {
        return []
      }
      
      return meteoStationParams.compactMap { parameter -> [String: String]? in
        guard let value = parameter.value else {
          return nil
        }
        
        return [
          "name": parameter.name,
          "value": value
        ]
      }.map { $0 }
      
    case let .road(roadStation):
      
      return roadStation.weatherData.map({ parameter -> [String: String] in
        return [
          "name": parameter.label,
          "value": parameter.value
        ]
      })
    }
  }
}

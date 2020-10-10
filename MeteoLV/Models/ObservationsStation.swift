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
extension ObservationStation {
  
  var title: String {
    guard let temperature = temperature else {
      return name
    }
    
    return "\(name) \(temperature)"
  }
  
  var isFavorited: Bool {
    defaults.favorites.contains(id)
  }
  
  var isHome: Bool {
    guard let userDefaults = UserDefaults(suiteName: "group.com.fassko.MeteoLV"),
      let home = userDefaults.string(forKey: "home") else {
        return false
    }
    
    return home == id
  }
  
  func setHome(_ completion: @escaping () -> Void) {
    let userDefaults = UserDefaults(suiteName: "group.com.fassko.MeteoLV")
    let home = userDefaults?.string(forKey: "home")
    
    if home == id {
      userDefaults?.removeObject(forKey: "home")
    } else {
      userDefaults?.set(id, forKey: "home")
    }
    
    completion()
  }
  
  func toggleFavorite(_ completion: @escaping () -> Void) {
    let favoritesArray = defaults.favorites
    var favorites = Set(favoritesArray)
    
    if favorites.contains(id) {
      favorites.remove(id)
    } else {
      favorites.insert(id)
    }
    defaults.set(Array(favorites), forKey: Constants.favoritesKey)
    completion()
  }
  
  private static func compare(_ lhs: ObservationStation, _ rhs: ObservationStation) -> Bool {
    let range = lhs.name.startIndex..<lhs.name.endIndex
    let comparisonResult = lhs.name.compare(rhs.name,
                                            options: .caseInsensitive,
                                            range: range,
                                            locale: Locale(identifier: "lv_LV"))
    
    switch comparisonResult {
    case .orderedAscending:
      return true
    case .orderedSame:
      return true
    case .orderedDescending:
      return false
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

extension Data {
  var hexDescription: String {
    return reduce("") {$0 + String(format: "%02x", $1)}
  }
}

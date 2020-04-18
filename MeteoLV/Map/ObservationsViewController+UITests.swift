//
//  ObservationsViewController+UITests.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 08/12/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation

import MeteoLVProvider

extension ObservationsViewController {
  internal func runUITests() {
    if CommandLine.arguments.contains("-meteoLVStation") {
      do {
        let contents = try loadFile("meteoLVStation")!
        let data = contents.data(using: .utf8)!
        let station = try JSONDecoder().decode(Station.self, from: data)
        coordinator?.showObservationStation(ObservationStation.meteo(station))
      } catch {
        assertionFailure(error.localizedDescription)
      }
    }
    
    if CommandLine.arguments.contains("-lvRoadStation") {
      do {
        let contents = try loadFile("roadLVStation")!
        let data = contents.data(using: .utf8)!
        let station = try JSONDecoder().decode(LatvianRoadsStation.self, from: data)
        coordinator?.showObservationStation(ObservationStation.road(station))
      } catch {
        assertionFailure(error.localizedDescription)
      }
    }
  }
  
  private func loadFile(_ name: String) throws -> String? {
    guard let filepath = Bundle.main.path(forResource: name, ofType: "json") else {
      return nil
    }
    
    return try String(contentsOfFile: filepath)
  }
}

//
//  FavoritesTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation

class FavoritesTableViewController: ListingTableViewController, Storyboarded {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "List".localized
  }
  
  override func loadData() {
    meteoDataProvider.observations { [weak self] result in
      switch result {
      case .success(let meteoLVData):
        self?.stations.removeAll()
        var tmpStationsData = meteoLVData.map { ObservationStation.meteo($0) }.filter { $0.isFavorited }
        
        self?.meteoDataProvider.latvianRoadsObservations { [weak self] result in
          switch result {
          case .success(let lvRoadsData):
            let lvRoadStations = lvRoadsData.map { ObservationStation.road($0) }.filter { $0.isFavorited }
            tmpStationsData.append(contentsOf: lvRoadStations)
            self?.stations.append(contentsOf: tmpStationsData.sorted(by: ==))
            
            DispatchQueue.main.async {
              self?.tableView.reloadData()
            }
          case .failure(let error):
            debugPrint("Failed to load LV roads \(error)")
          }
        }
        
      case .failure(let error):
        debugPrint("Failed to load Meteo LV data \(error)")
      }
    }
  }
}

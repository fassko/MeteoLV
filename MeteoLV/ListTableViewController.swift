//
//  ListTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 05/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import UIKit

import MeteoLVProvider

class ListTableViewController: UITableViewController, Storyboarded {
  
  weak var coordinator: ListCoordinator?
  
  private let meteoDataProvider = MeteoLVProvider()
  
  var stations = [ObservationStation]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "List".localized
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
    target: self,
    action: #selector(loadData))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadData()
  }
  
  @objc
  private func loadData() {
    meteoDataProvider.observations { [weak self] result in
      switch result {
      case .success(let meteoLVData):
        var tmpStationsData = meteoLVData.map { ObservationStation.meteo($0) }
        
        self?.meteoDataProvider.latvianRoadsObservations { [weak self] result in
          switch result {
          case .success(let lvRoadsData):
            tmpStationsData.append(contentsOf: lvRoadsData.map { ObservationStation.road($0) })
            tmpStationsData.sort()
            
            self?.stations.append(contentsOf: tmpStationsData)
            
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
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    stations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    switch stations[indexPath.row] {
    case .meteo(let meteoStation):
      cell.textLabel?.text = meteoStation.name
      cell.detailTextLabel?.text = meteoStation.temperature
    case .road(let lvRoadStation):
      cell.textLabel?.text = lvRoadStation.name
      cell.detailTextLabel?.text = lvRoadStation.temperature
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let station = stations[indexPath.row]
    coordinator?.showObservationStation(station)
  }
}

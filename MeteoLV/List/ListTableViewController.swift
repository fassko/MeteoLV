//
//  ListTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 05/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import UIKit

import MeteoLVProvider

class ListingTableViewController: UITableViewController {
  
  var stations = [ObservationStation]()
  var coordinator: ListCoordinatorProtocol?
  let meteoDataProvider = MeteoLVProvider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh,
      target: self,
      action: #selector(executeLoadData))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    executeLoadData()
  }
  
  @objc private func executeLoadData() {
    loadData()
  }
  
  func loadData() {
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
  
  func navigate(with station: ObservationStation) {
  }
}

class ListTableViewController: ListingTableViewController, Storyboarded {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "List".localized
  }
  
  override func loadData() {
    meteoDataProvider.observations { [weak self] result in
      switch result {
      case .success(let meteoLVData):
        self?.stations.removeAll()
        var tmpStationsData = meteoLVData.map { ObservationStation.meteo($0) }
        
        self?.meteoDataProvider.latvianRoadsObservations { [weak self] result in
          switch result {
          case .success(let lvRoadsData):
            tmpStationsData.append(contentsOf: lvRoadsData.map { ObservationStation.road($0) })
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

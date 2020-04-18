//
//  ListTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 05/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import UIKit
import os.log

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
      case .success(let observationStations):
        self?.stations.removeAll()
        let stations = observationStations.sorted(by: ==)
        self?.stations.append(contentsOf: stations)

        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      case let .failure(error):
        os_log("%s", log: OSLog.standard, type: OSLogType.error, error.localizedDescription)
      }
    }
  }
}

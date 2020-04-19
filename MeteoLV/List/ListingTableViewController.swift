//
//  ListingTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 19/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation
import UIKit

import MeteoLVProvider

class ListingTableViewController: UITableViewController {
  
  var stations = [ObservationStation]()
  var coordinator: ListCoordinatorProtocol?
  let meteoDataProvider = MeteoLVProvider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addRefreshControl()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh,
      target: self,
      action: #selector(executeLoadData))
  }
  
  private func addRefreshControl() {
    refreshControl = UIRefreshControl()
    guard let refreshControl = self.refreshControl else {
      return
    }
    
    refreshControl.addTarget(self, action: #selector(executeLoadData), for: .valueChanged)
    tableView.addSubview(refreshControl)
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

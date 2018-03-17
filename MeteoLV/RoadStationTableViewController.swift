//
//  RoadStationTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 17/03/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

import MeteoLVProvider

class RoadStationTableViewController: UITableViewController {
  
  /// Station
  var station: LatvianRoadsStation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = station.name
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
  
extension RoadStationTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return station.weatherData.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "roadStationCell", for: indexPath)
    
    let weatherData = station.weatherData[indexPath.row]
    
    cell.textLabel?.text = weatherData.label
    cell.detailTextLabel?.text = weatherData.value
    
    return cell
  }
}

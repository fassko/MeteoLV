//
//  StationViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

import MeteoLVProvider

class StationViewController: UITableViewController {

  /// Station
  var station: Station!
  
  /// Station parameters
  var parameters: [Parameter] {
    guard let parameters = station.parameters else { return [] }
    
    return parameters.filter({ $0.value != nil })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = station.name
  }
  
  // MARK: - Table view controller
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parameters.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)

    let parameter = parameters[indexPath.row]

    cell.textLabel?.text = parameter.name
    cell.detailTextLabel?.text = parameter.value
    
    return cell
  }
}

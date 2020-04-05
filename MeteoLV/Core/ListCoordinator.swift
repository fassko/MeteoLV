//
//  ListCoordinator.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 05/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation
import UIKit

class ListCoordinator: Coordinator {
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let listTableViewController = ListTableViewController.instantiate()
    listTableViewController.coordinator = self
    navigationController.pushViewController(listTableViewController, animated: false)
  }
  
  func showObservationStation(_ station: ObservationStation) {
    let stationViewController = StationViewController.instantiate()
    stationViewController.station = station
    navigationController.pushViewController(stationViewController, animated: true)
  }
  
}

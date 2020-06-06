//
//  MapViewCooordinator.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 28/10/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation
import UIKit

import MeteoLVProvider

class MapViewCooordinator: Coordinator {
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let observationsViewController = ObservationsViewController.instantiate()
    observationsViewController.coordinator = self
    navigationController.pushViewController(observationsViewController, animated: false)
  }
  
  func showObservationStation(_ station: ObservationStation) {
    let stationViewController = StationViewController.instantiate()
    stationViewController.station = station
    navigationController.pushViewController(stationViewController, animated: true)
  }
  
  func showInfo() { 
    let infoViewController = InfoViewController.instantiate()
    navigationController.pushViewController(infoViewController, animated: true)
  }
}

//
//  FavoritesViewCoordinator.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 06/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation
import UIKit

import MeteoLVProvider

class FavoritesViewCoordinator: ListCoordinatorProtocol {
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let favoritesTableViewController = FavoritesTableViewController.instantiate()
    favoritesTableViewController.coordinator = self
    navigationController.pushViewController(favoritesTableViewController, animated: false)
  }
  
  func showObservationStation(_ station: ObservationStation) {
    let stationViewController = StationViewController.instantiate()
    stationViewController.station = station
    navigationController.pushViewController(stationViewController, animated: true)
  }
}

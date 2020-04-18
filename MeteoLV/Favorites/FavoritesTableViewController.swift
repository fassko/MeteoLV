//
//  FavoritesTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation
import os.log

class FavoritesTableViewController: ListingTableViewController, Storyboarded {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "List".localized
  }
  
  override func loadData() {
    meteoDataProvider.observations { [weak self] result in
      switch result {
      case .success(let observationStations):
        self?.stations.removeAll()
        let stations = observationStations.filter { $0.isFavorited }.sorted(by: ==)
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

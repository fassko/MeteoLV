//
//  ListTableViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 05/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import UIKit
import os.log

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
          self?.refreshControl?.endRefreshing()
        }
      case let .failure(error):
        os_log("%s", log: OSLog.standard, type: OSLogType.error, error.localizedDescription)
      }
    }
  }
}

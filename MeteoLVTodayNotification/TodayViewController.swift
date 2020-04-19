//
//  TodayViewController.swift
//  MeteoLVTodayNotification
//
//  Created by Kristaps Grinbergs on 18/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import UIKit
import NotificationCenter
import os.log

import MeteoLVProvider

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var containerStackView: UIStackView!
  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var windLabel: UILabel!
  
  @IBOutlet weak var setHomeLocationLabel: UILabel!
  
  private let meteoDataProvider = MeteoLVProvider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func openApp(_ sender: AnyObject) {
    guard let appURL = URL(string: "weatherLatvia://home") else {
      return
    }
    
    extensionContext?.open(appURL)
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    guard let userDefaults = UserDefaults(suiteName: "group.com.fassko.MeteoLV"),
      let home = userDefaults.string(forKey: "home") else {
        containerStackView.isHidden = true
        setHomeLocationLabel.isHidden = false
        completionHandler(.noData)
        return
    }
    
    meteoDataProvider.observations { [weak self] result in
      switch result {
      case let .success(stations):
        
        guard let homeStation = stations.first(where: { $0.id == home }) else {
          completionHandler(.noData)
          return
        }
        
        self?.locationName.text = homeStation.name
        self?.temperatureLabel.text = homeStation.temperature
        self?.windLabel.text = homeStation.wind
        self?.containerStackView.isHidden = false
        self?.setHomeLocationLabel.isHidden = true
        completionHandler(NCUpdateResult.newData)
        
      case let .failure(error):
        debugPrint(error)
      }
    }
  }
}

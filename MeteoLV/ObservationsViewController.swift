//
//  ObservationsViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

import MapKit
import MeteoLVProvider
import os.log

class ObservationsViewController: UIViewController, Storyboarded {
  
  weak var coordinator: MainCoordinator?
  
  @IBOutlet private weak var mapView: MKMapView!
  
  private let meteoDataProvider = MeteoLVProvider()
  
  private var lastUpdateDate: Date?
  
  private var needUpdate: Bool {
    guard let lastUpdateDate = lastUpdateDate else {
      return true
    }
    
    let currentTimestamp = Date()
    
    return currentTimestamp.timeIntervalSince(lastUpdateDate) > 5 * 60
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupMap()
    
    runUITests()
  }
  
  override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     refreshData()
   }
  
  private func setupMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 56.8800000, longitude: 24.6061111)
    let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 200000, longitudinalMeters: 500000)
    mapView.setRegion(region, animated: false)
  }
  
  private func setupNavigationBar() {
    title = "Map".localized
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Info".localized,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(info(_:)))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                        target: self,
                                                        action: #selector(refreshObservations))
  }
  
  private func loadObservations() {
    meteoDataProvider.observations { [weak self] result in
      switch result {
      case let .success(stations):
        let annotations = stations.map { station -> StationAnnotation in
          let annotation = StationAnnotation(station: .meteo(station))
          annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
          annotation.title = station.name
          annotation.subtitle = station.temperature
          annotation.accessibilityLabel = station.name
          annotation.accessibilityIdentifier = station.name
          
          return annotation
        }
        
        self?.add(annotations)
      case let .failure(error):
        os_log("%s", log: OSLog.standard, type: OSLogType.error, error.localizedDescription)
      }
    }
  }
  
  private func loadLatvianRoadsObservations() {
    meteoDataProvider.latvianRoadsObservations { [weak self] result in
      switch result {
      case let .success(stations):
        let annotations = stations.map { station -> StationAnnotation in
          let annotation = StationAnnotation(station: .road(station))
          annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
          annotation.title = station.name
          annotation.subtitle = station.temperature
          annotation.accessibilityLabel = station.name
          annotation.accessibilityIdentifier = station.name
          
          return annotation
        }
        
        self?.add(annotations)
      case let .failure(error):
        os_log("%s", log: OSLog.standard, type: OSLogType.error, error.localizedDescription)
      }
    }
  }
  
  private func add(_ annotations: [StationAnnotation]) {
    lastUpdateDate = Date()
    
    DispatchQueue.main.async {
      self.mapView.addAnnotations(annotations)
    }
  }
}

// MARK: - UI lifecycle
extension ObservationsViewController {
  @IBAction func info(_ sender: Any) {
    coordinator?.showInfo()
  }
  
  @IBAction func refreshObservations() {
    removeAnnotations()
    lastUpdateDate = nil
    
    refreshData()
  }
  
  private func removeAnnotations() {
    mapView.removeAnnotations(self.mapView.annotations)
  }
  
  private func refreshData() {
    if needUpdate {
      removeAnnotations()
      loadObservations()
      loadLatvianRoadsObservations()
    }
  }
}

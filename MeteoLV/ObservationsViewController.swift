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

class ObservationsViewController: UIViewController, Storyboarded {
  
  private let meteoDataProvider = MeteoLVProvider()
  
  weak var coordinator: MainCoordinator?

  /// Map view
  @IBOutlet weak var mapView: MKMapView!
  
  private let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupMap()
    
    loadObservations()
    loadLatvianRoadsObservations()
    
    runUITests()
  }
  
  private func setupMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 56.8800000, longitude: 24.6061111)
    let region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 200000, 500000)
    mapView.setRegion(region, animated: false)
  }
  
  private func setupNavigationBar() {
    title = "Novērojumi"
    
    let infoButton = UIBarButtonItem(title: "Info",
                                      style: .plain,
                                      target: self,
                                      action: #selector(info(_:)))
    navigationItem.leftBarButtonItem = infoButton
    
    let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                       target: self,
                                       action: #selector(refreshObservations(_:)))
    navigationItem.rightBarButtonItem = reloadButton
  }
  
  /**
    Load observations
  */
  private func loadObservations() {
    meteoDataProvider.observations { result in
      switch result {
      case let .success(stations):
        let annoations = stations.map { station -> StationAnnotation in
          let annotation = StationAnnotation(station: .meteo(station))
          annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
          annotation.title = station.name
          annotation.subtitle = station.temperature
          annotation.accessibilityLabel = station.name
          annotation.accessibilityIdentifier = station.name
          
          return annotation
        }
        
        DispatchQueue.main.async {
          self.mapView.addAnnotations(annoations)
        }
      case let .failure(error):
        print(error)
      }
    }
  }
  
  /**
   Load Latvian roads observation
  */
  private func loadLatvianRoadsObservations() {
    meteoDataProvider.latvianRoadsObservations { result in
      switch result {
      case let .success(stations):
        let annoations = stations.map { station -> StationAnnotation in
          let annotation = StationAnnotation(station: .road(station))
          annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
          annotation.title = station.name
          annotation.subtitle = station.temperature
          annotation.accessibilityLabel = station.name
          annotation.accessibilityIdentifier = station.name
          
          return annotation
        }
        
        DispatchQueue.main.async {
          self.mapView.addAnnotations(annoations)
        }
      case let .failure(error):
        print(error)
      }
    }
  }
}

// MARK: - UI lifecycle
extension ObservationsViewController {
  @objc
  @IBAction func info(_ sender: Any) {
    coordinator?.showInfo()
  }
  
  @objc
  @IBAction func refreshObservations(_ sender: Any) {
    self.mapView.removeAnnotations(self.mapView.annotations)
    loadObservations()
    loadLatvianRoadsObservations()
  }
}

// MARK: - UI tests
extension ObservationsViewController {
  private func runUITests() {
    if CommandLine.arguments.contains("-meteoLVStation") {
      do {
        let data = """
        {
          "id": "RIRU99PA",
          "name": "Rūjiena",
          "latitude": 57.8867,
          "longitude": 25.3717,
          "icon": null,
          "iconTitle": null,
          "temperature": "+0,6",
          "parameters": [
          {
          "name": "Temperatūra (°C)",
          "parameterId": "121",
          "value": "+ 0,6"
          },
          {
          "name": "Vēja virziens",
          "parameterId": "117",
          "value": "ZA"
          },
          {
          "name": "Vēja ātrums (m/s)",
          "parameterId": "113",
          "value": "3/5"
          },
          {
          "name": "Mitrums (%)",
          "parameterId": "114",
          "value": "90"
          },
          {
          "name": "Spiediens (mm Hg)",
          "parameterId": "118",
          "value": "768,2"
          },
          {
          "name": "Nokrišņi (mm)",
          "parameterId": "119",
          "value": null
          },
          {
          "name": "Sniegs (cm)",
          "parameterId": "120",
          "value": "0"
          },
          {
          "name": "Redzamība (m)",
          "parameterId": "116",
          "value": "20000"
          }
          ]
        }
        """.data(using: .utf8)!
        let station = try JSONDecoder().decode(Station.self, from: data)
        coordinator?.showObservationStation(ObservationStation.meteo(station))
      } catch {
        assertionFailure(error.localizedDescription)
      }
    }
    
    if CommandLine.arguments.contains("-lvRoadStation") {
      do {
        //swiftlint:disable line_length
        let data = """
          {
            "attributes": {
                "LVC_CMS.dbo.view_cms_statuss.nosaukums": "Strenči",
                "GIS.DBO.LVC_CMS.Y": 57.651187999999998,
                "GIS.DBO.LVC_CMS.X": 25.863773160000001,
                "LVC_CMS.dbo.view_cms_statuss.CMS_STATUS": "Gaiss:u003cfont style='font-size:12px;'u003eu003cdiv class='wi wi-thermometer'u003eu003c/divu003e&nbsp;-0.8°C u003c/fontu003e u003cbr/u003eMitrums:u003cfont style='font-size:12px;'u003eu003cdiv class='wi wi-humidity'u003eu003c/divu003e&nbsp;100% u003c/fontu003eu003cbr/u003eVējš:u003cfont style='font-size:12px;'u003eu003cdiv class='wi wi-wind'u003eu003c/divu003e&nbsp;0m/su003c/fontu003e",
                "GIS.DBO.LVC_CMS.STATION": "LV17",
                "LVC_CMS.dbo.view_cms_statuss.acid": "A3",
                "LVC_CMS.dbo.view_cms_statuss.km": 102
              },
              "geometry": {
                "x": 25.863773167000033,
                "y": 57.65118800700003
              }
          }
        """.data(using: .utf8)!
        let station = try JSONDecoder().decode(LatvianRoadsStation.self, from: data)
        coordinator?.showObservationStation(ObservationStation.road(station))
      } catch {
        assertionFailure(error.localizedDescription)
      }
    }
  }
}

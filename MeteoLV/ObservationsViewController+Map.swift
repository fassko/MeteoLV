//
//  ObservationsViewController+Map.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 08/12/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation
import MapKit

// MARK: - MapView delegate methods
extension ObservationsViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "marker"
    var view: MKMarkerAnnotationView
    
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.animatesWhenAdded = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
    view.displayPriority = .required
    
    if let stationAnnotation = view.annotation as? StationAnnotation {
      switch stationAnnotation.station {
      case .meteo:
        view.markerTintColor = UIColor(red: 0.05, green: 0.29, blue: 0.53, alpha: 1.0)
      case .road:
        view.markerTintColor = .lightGray
      }
    }
    
    return view
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    
    guard let station = view.annotation as? StationAnnotation else {
      return
    }
    
    coordinator?.showObservationStation(station.station)
    mapView.deselectAnnotation(view.annotation, animated: true)
  }
}

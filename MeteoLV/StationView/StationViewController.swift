//
//  StationViewController.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

import MeteoLVProvider

class StationViewController: UITableViewController, Storyboarded {

  var station: ObservationStation!
  
  @IBOutlet private weak var favoriteButton: UIBarButtonItem!
  @IBOutlet private weak var homeButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = station.name
    updateFavoriteButton()
    updateHomeButton()
  }
}

// MARK: - UI Actions
extension StationViewController {
  @IBAction func favorite(_ sender: Any) {
    station.toggleFavorite { [weak self] in
      self?.updateFavoriteButton()
    }
  }
  
  @IBAction func setHome(_ sender: Any) {
    station.setHome { [weak self] in
      self?.updateHomeButton()
    }
  }
  
  @IBAction func share(_ sender: Any) {
    guard let temperature = station.temperature, let wind = station.wind else {
      return
    }
    
    let text = "\(station.name) \(temperature) \(wind)"
    let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
    navigationController?.present(activityViewController, animated: true, completion: {})
  }
  
  private func updateFavoriteButton() {
    UIView.animate(withDuration: 0.5) { [weak self] in
      self?.favoriteButton.image = self?.station.isFavorited ?? false ? .favoritesFull : .favorites
    }
  }
  
  private func updateHomeButton() {
    UIView.animate(withDuration: 0.5) { [weak self] in
      self?.homeButton.image = self?.station.isHome ?? false ? .homeFull : .home
    }
  }
}

// MARK: - Table view controller
extension StationViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    station.parameters.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)

    let parameter = station.parameters[indexPath.row]
    cell.textLabel?.text = parameter["name"]
    cell.detailTextLabel?.text = parameter["value"]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
}

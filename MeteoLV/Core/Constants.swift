//
//  Constants.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 08/12/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
  static var meteoLVTintColor = UIColor(red: 0.05, green: 0.29, blue: 0.53, alpha: 1.0)
  static var roadsTintColor = UIColor.lightGray
  static let favoritesKey = "favorites"
}

public let defaults = UserDefaults.standard

public extension UserDefaults {
  var favorites: [String] {
    stringArray(forKey: Constants.favoritesKey) ?? []
  }
}

extension UIImage {
  static let favoritesFull = UIImage(systemName: "star.fill")
  static let favorites = UIImage(systemName: "star")
  static let homeFull = UIImage(systemName: "house.fill")
  static let home = UIImage(systemName: "house")
}

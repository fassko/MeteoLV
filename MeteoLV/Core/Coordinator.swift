//
//  Coordinator.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 28/10/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

protocol Coordinator {
  
  var navigationController: UINavigationController { get set }
  
  func start()
}

//
//  ListCoordinatorProtocol.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 06/04/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation

protocol ListCoordinatorProtocol: Coordinator {
  func showObservationStation(_ station: ObservationStation)
}

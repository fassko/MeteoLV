//
//  Station+Extension.swift
//  MeteoLVWidgetExtension
//
//  Created by Kristaps Grinbergs on 18/10/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Foundation

import MeteoLVProvider

extension Station {
  static var example: Station {
    let data = """
    {
              \"id\": \"RIGASLU\",
              \"name\": \"Rīga - LU\",
              \"latitude\": 56.950556,
              \"longitude\": 24.116111,
              \"icon\": null,
              \"iconTitle\": null,
              \"temperature\": \"+20,7\",
              \"parameters\": [
                {
                  \"name\": \"Temperatūra (°C)\",
                  \"parameterId\": \"121\",
                  \"value\": \"+   20,7\"
                },
                {
                  \"name\": \"Vēja virziens\",
                  \"parameterId\": \"117\",
                  \"value\": \"DR\"
                },
                {
                  \"name\": \"Vēja ātrums (m/s)\",
                  \"parameterId\": \"113\",
                  \"value\": \"4/8\"
                },
                {
                  \"name\": \"Mitrums (%)\",
                  \"parameterId\": \"114\",
                  \"value\": \"68\"
                },
                {
                  \"name\": \"Spiediens (mm Hg)\",
                  \"parameterId\": \"118\",
                  \"value\": \"758,2\"
                },
                {
                  \"name\": \"Nokrišņi (mm)\",
                  \"parameterId\": \"119\",
                  \"value\": null
                },
                {
                  \"name\": \"Redzamība (m)\",
                  \"parameterId\": \"116\",
                  \"value\": \"20000\"
                }
              ]
            }
    """.data(using: .utf8)!
    
    return try! JSONDecoder().decode(Station.self, from: data)
  }
}

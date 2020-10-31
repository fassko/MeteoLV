//
//  IntentHandler.swift
//  MeteoLVSiri
//
//  Created by Kristaps Grinbergs on 19/10/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import Intents

import MeteoLVProvider

class IntentHandler: INExtension {
  override func handler(for intent: INIntent) -> Any {
    SiriIntentHandler()
  }
}

class SiriIntentHandler: NSObject, CurrentConditionsIntentHandling {
  func handle(intent: CurrentConditionsIntent, completion: @escaping (CurrentConditionsIntentResponse) -> Void) {
    guard let userDefaults = UserDefaults(suiteName: "group.com.fassko.MeteoLV"),
          let home = userDefaults.string(forKey: "home") else {
//      completion(.failure(error: "Please set the home location."))
      return
    }
    
    MeteoLVProvider().observations { result in
      switch result {
      case let .success(stations):
        
        guard let homeStation = stations.first(where: { $0.id == home }) else {
          return
        }
        
        completion(.success(temperature: homeStation.temperatureWithUnits.replacingOccurrences(of: ",", with: ".")))
      case let .failure(error):
        debugPrint(error)
      }
    }
  }
}

//
//  MeteoLVWidget.swift
//  MeteoLVWidget
//
//  Created by Kristaps Grinbergs on 18/10/2020.
//  Copyright © 2020 fassko. All rights reserved.
//

import WidgetKit
import SwiftUI

import MeteoLVProvider

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> MeteoLVEntry {
    MeteoLVEntry(date: Date(), observationStation: .meteo(.example))
  }
  
  func getSnapshot(in context: Context, completion: @escaping (MeteoLVEntry) -> ()) {
    let entry = MeteoLVEntry(date: Date(), observationStation: .meteo(.example))
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
    
    guard let userDefaults = UserDefaults(suiteName: "group.com.fassko.MeteoLV"),
          let home = userDefaults.string(forKey: "home") else {
      let entry = MeteoLVEntry(date: currentDate, observationStation: nil)
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
      return
    }
    
    MeteoLVProvider().observations { result in
      switch result {
      case let .success(stations):
        
        guard let homeStation = stations.first(where: { $0.id == home }) else {
          let entry = MeteoLVEntry(date: currentDate, observationStation: nil)
          let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
          completion(timeline)
          return
        }
        
        let entry = MeteoLVEntry(date: currentDate, observationStation: homeStation)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
      case let .failure(error):
        debugPrint(error)
      }
    }
  }
}

struct MeteoLVEntry: TimelineEntry {
  let date: Date
  let observationStation: ObservationStation?
}

struct CustomLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.icon
      configuration.title
    }
  }
}

struct SelectHomeLocationView: View {
  var body: some View {
    HStack(alignment: .center) {
      Label("Please select home location.", systemImage: "house")
        .multilineTextAlignment(.center)
        .font(.body)
        .labelStyle(CustomLabelStyle())
    }
  }
}

struct MeteoLVWidgetEntryView: View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack(alignment: .center) {
      if let observationStation = entry.observationStation {
        GroupBox(label: Text(observationStation.name), content: {
          VStack(spacing: 10) {
            Label(observationStation.temperatureWithUnits, systemImage: "thermometer")
              .minimumScaleFactor(0.5)
            Label(observationStation.wind!, systemImage: "wind")
              .minimumScaleFactor(0.5)
          }.padding(.vertical, 5)
        })
      } else {
        SelectHomeLocationView()
      }
    }.padding()
  }
}

@main
struct MeteoLVWidget: Widget {
  let kind: String = "MeteoLVWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      MeteoLVWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("WeatherLatvia")
    .description("WeatherLatvia sample widget")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct MeteoLVWidget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MeteoLVWidgetEntryView(entry: MeteoLVEntry(date: Date(), observationStation: nil))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
      MeteoLVWidgetEntryView(entry: MeteoLVEntry(date: Date(), observationStation: .meteo(.example)))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
      MeteoLVWidgetEntryView(entry: MeteoLVEntry(date: Date(), observationStation: .meteo(.example)))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDevice("iPhone 11 Pro")
      
      MeteoLVWidgetEntryView(entry: MeteoLVEntry(date: Date(), observationStation: nil))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDevice("iPhone 11 Pro")
    }
  }
}

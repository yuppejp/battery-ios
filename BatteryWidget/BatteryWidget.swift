//
//  BatteryWidget.swift
//  BatteryWidget
//
//  Created on 2022/09/17.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), batteryLevel: 0.8, batteryState: .charging)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, batteryLevel: 0.8, batteryState: .charging)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        // Battery Status
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryState = UIDevice.current.batteryState
        UIDevice.current.isBatteryMonitoringEnabled = false
        
        // debug
        if batteryLevel == -1 {
            let batteryLevel: Float = 0.8
            let batteryState = UIDevice.BatteryState.charging
            let entry = SimpleEntry(date: Date(), configuration: configuration, batteryLevel: batteryLevel, batteryState: batteryState)
            let nextDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            let timeline = Timeline(entries: [entry], policy: .after(nextDate))
            completion(timeline)
            return
        }

        let entry = SimpleEntry(date: Date(), configuration: configuration, batteryLevel: batteryLevel, batteryState: batteryState)
        let nextDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    let batteryLevel: Float
    let batteryState: UIDevice.BatteryState
    
    var discription: String {
        let discription: String
        
        switch batteryState {
        case .unknown: discription = "不明"
        case .unplugged: discription = "未接続"
        case .charging: discription = "充電中"
        case .full: discription = "満充電"
        default:  discription = "不明すぎ"
        }
        return discription
    }
}

struct BatteryWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var WidgetFamily

    var body: some View {
        switch WidgetFamily {
        case .systemSmall:
            // ホーム画面の小さいウィジェット
            SmallWidgetView(entry: entry)
        case .accessoryCircular:
            // ロック画面の丸型ウィジェット
            CircularWidgetView(entry: entry)
        case .accessoryRectangular:
            // ロック画面の横長のウィジェット
            RectangularWidgetView(entry: entry)
        case .accessoryInline:
            // ロック画面の時計の上のウィジェット
            InlineWidgetView(entry: entry)
        default:
            HStack {
                SmallWidgetView(entry: entry)
                Text(WidgetFamily.description)
            }
            .padding(2)
        }
    }
}

@main

struct BatteryWidget: Widget {
    let kind: String = "BatteryWidget"
    var supportedFamilies: [WidgetFamily] = []
    
    init() {
        if #available(iOSApplicationExtension 16.0, *) {
            supportedFamilies = [.systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline]
        } else {
            supportedFamilies = [.systemSmall]
        }
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BatteryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bettery Widget")
        .description("This is an example widget.")
        .supportedFamilies(supportedFamilies)
    }
}

@available(iOSApplicationExtension 16.0, *)
struct BatteryWidget_Previews: PreviewProvider {
    static var previews: some View {
        BatteryWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), batteryLevel: 0.8, batteryState: .charging))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

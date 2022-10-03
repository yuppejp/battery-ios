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
        let appSetting = AppSetting()
        let deviceInfo = DeviceInfo(batteryLevel: 0.8, batteryState: .charging)
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), appSetting: appSetting, deviceInfo: deviceInfo)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
                     completion: @escaping (SimpleEntry) -> ()) {
        let appSetting = AppSetting()
        let deviceInfo = DeviceInfo()
        let entry = SimpleEntry(date: Date(), configuration: configuration, appSetting: appSetting, deviceInfo: deviceInfo)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context,
                     completion: @escaping(Timeline<SimpleEntry>) -> ()) {
        let appSetting = AppSetting()
        let deviceInfo = DeviceInfo()
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), configuration: configuration, appSetting: appSetting, deviceInfo: deviceInfo)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)

//        let deviceInfo = DeviceInfo()
//        let entry = SimpleEntry(date: Date(), configuration: configuration, deviceInfo: deviceInfo)
//        let nextDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
//        let timeline = Timeline(entries: [entry], policy: .after(nextDate))
//        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    let appSetting: AppSetting
    let deviceInfo: DeviceInfo
}

struct BatteryWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var WidgetFamily

    var body: some View {
        switch WidgetFamily {
        case .systemSmall:
            // home screen: small
            SmallWidgetView(entry: entry)
        case .accessoryCircular:
            // lock screen: circular
            CircularWidgetView(entry: entry)
        case .accessoryRectangular:
            // lock screen: rectangular
            RectangularWidgetView(entry: entry)
        case .accessoryInline:
            // lock screen: inline
            InlineWidgetView(entry: entry)
        default:
            Text("Unsupported")
                .padding()
        }
    }
}

@main
struct BatteryWidget: Widget {
    let kind: String = "com.yuupejp.Battery.BatteryWidget"
    var supportedFamilies: [WidgetFamily] = []
    
    init() {
        if #available(iOSApplicationExtension 16.0, *) {
            supportedFamilies = [.systemSmall,
                                 .accessoryCircular, .accessoryRectangular, .accessoryInline]
        } else {
            supportedFamilies = [.systemSmall]
        }
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BatteryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WidgetDisplayName")
        .description("WidgetDescription")
        .supportedFamilies(supportedFamilies)
    }
}

@available(iOSApplicationExtension 16.0, *)
struct BatteryWidget_Previews: PreviewProvider {
    static let localizationIds = ["en", "ja"]
    static let appSetting = AppSetting()
    static let deviceInfo = DeviceInfo(batteryLevel: 0.8, batteryState: .charging)

    static var previews: some View {
        ForEach(localizationIds, id: \.self) { id in
            let entry = SimpleEntry(date: Date(),
                                    configuration: ConfigurationIntent(),
                                    appSetting: appSetting,
                                    deviceInfo: deviceInfo)
            BatteryWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Widget - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}

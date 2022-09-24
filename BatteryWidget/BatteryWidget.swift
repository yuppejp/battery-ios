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
        let deviceInfo = DeviceInfo(batteryLevel: 0.8, batteryState: .charging)
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), deviceInfo: deviceInfo)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
                     completion: @escaping (SimpleEntry) -> ()) {
        let deviceInfo = DeviceInfo()
        let entry = SimpleEntry(date: Date(), configuration: configuration, deviceInfo: deviceInfo)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context,
                     completion: @escaping(Timeline<SimpleEntry>) -> ()) {
        let deviceInfo = DeviceInfo()
        let entry = SimpleEntry(date: Date(), configuration: configuration, deviceInfo: deviceInfo)
        let nextDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
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

struct BatteryWidgetEntryView2 : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var WidgetFamily

    var body: some View {
        switch WidgetFamily {
        case .accessoryCircular:
            // lock screen: circular
            CircularWidgetView2(entry: entry)
        default:
            Text("Unsupported")
                .padding()
        }
    }
}

struct BatteryWidget: Widget {
    let kind: String = "com.yuupejp.Battery.BatteryWidget"
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
        .configurationDisplayName("WidgetDisplayName1")
        .description("WidgetDescription")
        .supportedFamilies(supportedFamilies)
    }
}

struct BatteryWidget2: Widget {
    let kind: String = "com.yuupejp.Battery.BatteryWidget2"
    var supportedFamilies: [WidgetFamily] = []
    
    init() {
        if #available(iOSApplicationExtension 16.0, *) {
            supportedFamilies = [.accessoryCircular]
        } else {
            supportedFamilies = []
        }
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BatteryWidgetEntryView2(entry: entry)
        }
        .configurationDisplayName("WidgetDisplayName2")
        .description("WidgetDescription")
        .supportedFamilies(supportedFamilies)
    }
}

@main
struct ExampleWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        BatteryWidget()
        BatteryWidget2()
    }
}

@available(iOSApplicationExtension 16.0, *)
struct BatteryWidget_Previews: PreviewProvider {
    static let localizationIds = ["en", "ja"]

    static var previews: some View {
        let deviceInfo = DeviceInfo()
        
        ForEach(localizationIds, id: \.self) { id in
            Group {
                BatteryWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),
                                                          deviceInfo: deviceInfo))
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
                    .previewDisplayName("Widget1 - \(id)")
                    .environment(\.locale, .init(identifier: id))
                
                BatteryWidgetEntryView2(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),
                                                          deviceInfo: deviceInfo))
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
                    .previewDisplayName("Widget2 - \(id)")
                    .environment(\.locale, .init(identifier: id))
            }
        }
    }
}

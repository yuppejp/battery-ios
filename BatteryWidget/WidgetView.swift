//
//  WidgetView.swift
//  BatteryWidgetExtension
//
//  Created on 2022/09/17
//

import SwiftUI

struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.appSetting.useCircle {
            ZStack {
                RingProgressView(value: entry.deviceInfo.batteryLevel,
                                 lineWidth: 6.0,
                                 symboleName: entry.deviceInfo.batteryState == .charging ? "bolt.fill" : "",
                                 useGreen: entry.appSetting.useGreen)
                .offset(y: entry.appSetting.showDetectionTime ? -4 : 0)
                
                VStack(spacing: 0) {
                    if entry.appSetting.showIcon {
                        Image(systemName: entry.appSetting.useBatterySymbole ? entry.deviceInfo.battrySymbole : "iphone")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                        .font(entry.appSetting.useBatterySymbole ? .title : .largeTitle)
                    + Text("%")
                        .font(.body)
                    
                    if entry.deviceInfo.batteryState != .unplugged {
                        Text(entry.deviceInfo.batteryDiscription)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .offset(y: entry.appSetting.showDetectionTime ? -4 : 0)

                if entry.appSetting.showDetectionTime {
                    HStack(spacing: 0) {
                        // workaround for center alignment issue
                        Text("\(Text(entry.date.toString("HH:mm"))) \(Text(entry.date, style: .offset))")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: 14)
                }
            }
            .padding(18)
        } else {
            GeometryReader{ geometry in
                ZStack {
                    ArcProgressView(value: entry.deviceInfo.batteryLevel,
                                    lineWidth: 6.0,
                                    symboleName: entry.deviceInfo.battrySymbole,
                                    useGreen: entry.appSetting.useGreen)
                    VStack {
                        Text(entry.deviceInfo.batteryLevel.toPercentString())
                            .font(.largeTitle)
                        if entry.appSetting.showIcon {
                            Image(systemName: entry.appSetting.useBatterySymbole ? entry.deviceInfo.battrySymbole : "iphone")
                                .renderingMode(.original)
                                .font(.title)
                        }
                    }
                    
                    HStack {
                        Text("0")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: geometry.size.width / 10)
                        Text("100")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .offset(x: -(geometry.size.width / 12))
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: -(geometry.size.height / 10))
                    
                    if entry.appSetting.showDetectionTime {
                        HStack(spacing: 0) {
                            // workaround for center alignment issue
                            Text("\(Text(entry.date.toString("hh:mm"))) \(Text(entry.date, style: .offset))")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .offset(y: entry.appSetting.showDetectionTime ? 0 : 8)
            }
            .padding(14)
        }
    }
}

struct CircularWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.appSetting.useCircle {
            GeometryReader{ geometry in
                ZStack {
                    RingProgressView(value: entry.deviceInfo.batteryLevel, lineWidth: 6.0,
                                     symboleName: entry.deviceInfo.batteryState == .charging ? "bolt.fill" : "",
                                     monochrome: true)
                    
                    VStack(spacing: 0) {
                        if entry.appSetting.showIcon {
                            Image(systemName: entry.appSetting.useBatterySymbole ? entry.deviceInfo.battrySymbole : "iphone")
                                .imageScale(.large)
                                .offset(y: 1)
                            Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                                .font(.headline)
                                .offset(y: -1)
                        } else {
                            Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                                .font(.system(size: geometry.size.height * 0.43))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // workaround for when using GeometryReader
        } else {
            ZStack {
                ArcProgressView(value: entry.deviceInfo.batteryLevel,
                                lineWidth: 6.0,
                                symboleName: entry.deviceInfo.battrySymbole,
                                monochrome: true)
                
                Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                    .font(.system(size: 24))
                    .offset(y: -2)
                
                if entry.appSetting.showIcon {
                    VStack {
                        Image(systemName: entry.appSetting.useBatterySymbole ? entry.deviceInfo.battrySymbole : "iphone")
                            .font(.body)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: -6)
                }

                HStack(spacing: 0) {
                    Text("E")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 8)
                    Text("F")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: -8)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: -4)
            }
            .padding(0)
        }
    }
}

struct RectangularWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(spacing: 0) {
                CircularWidgetView(entry: entry)
                    .frame(width: geometry.size.height)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        SymboleView(entry: entry)
                            .font(.callout)
                        DiscriptionView(entry: entry)
                            .font(.caption)
                    }
                    Text(entry.date, style: .time)
                        .font(.callout)
                    Text(entry.date, style: .offset)
                        .font(.callout)
                }
            }
        }
    }
    
    private struct SymboleView: View {
        var entry: Provider.Entry
        
        var body: some View {
            if entry.deviceInfo.batteryState == .charging {
                Image(systemName: "bolt.fill")
            } else {
                Image(systemName: entry.deviceInfo.battrySymbole)
            }
        }
    }

    private struct DiscriptionView: View {
        var entry: Provider.Entry
        
        var body: some View {
            if entry.deviceInfo.batteryState == .unplugged {
                Text(entry.deviceInfo.batteryLevel.toPercentString())
            } else {
                Text(entry.deviceInfo.batteryDiscription)
            }
        }
    }
}

struct InlineWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: entry.appSetting.useBatterySymbole ?  entry.deviceInfo.battrySymbole : "iphone")
                .imageScale(.large)
            Text(entry.deviceInfo.batteryLevel.toPercentString())
        }
    }
}

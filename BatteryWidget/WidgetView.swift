//
//  WidgetView.swift
//  BatteryWidgetExtension
//
//  Created on 2022/09/17
//

import SwiftUI

struct SmallWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            RingProgressView(value: Double(entry.deviceInfo.batteryLevel),
                             lineWidth: 6.0,
                             systemName: entry.deviceInfo.batteryState == .charging ? "bolt.fill" : "")
            VStack(spacing: 0) {
                Image(systemName: "iphone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                    .font(.title)
                + Text("%")
                    .font(.body)
                if entry.deviceInfo.batteryState != .unplugged {
                    Text(entry.deviceInfo.batteryDiscription)
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text(entry.date, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
    }
}

struct CircularWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            RingProgressView(value: Double(entry.deviceInfo.batteryLevel), lineWidth: 6.0,
                             systemName: entry.deviceInfo.batteryState == .charging ? "bolt.fill" : "",
                             monochrome: true)
            VStack(spacing: 0) {
                Image(systemName: "iphone")
                    .imageScale(.large)
                    .offset(y: 1)
                Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                    .font(.headline)
                    .offset(y: -1)
//                + Text("%")
//                    .font(.system(size: 10))
            }
        }
    }
}

struct CircularWidgetView2 : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            RingProgressView(value: Double(entry.deviceInfo.batteryLevel), lineWidth: 6.0,
                             systemName: entry.deviceInfo.batteryState == .charging ? "bolt.fill" : "",
                             monochrome: true)
            VStack(spacing: 0) {
                Image(systemName: entry.deviceInfo.getBattrySymbole())
                    .imageScale(.large)
                    .offset(y: 1)
                Text(entry.deviceInfo.batteryLevel.toPercentString(percentSymbol: ""))
                    .font(.headline)
            }
        }
    }
}

struct RectangularWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            ZStack {
                RingProgressView(value: Double(entry.deviceInfo.batteryLevel),
                                 lineWidth: 6.0,
                                 systemName: entry.deviceInfo.batteryState == .charging ? "bolt.fill" : "",
                                 monochrome: true)
                VStack {
                    Image(systemName: "iphone")
                        .resizable()
                        .scaledToFit()
                        .padding(14)
                }
            }
            VStack {
                Text(entry.deviceInfo.batteryLevel.toPercentString())
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if entry.deviceInfo.batteryState != .unplugged {
                    Text(entry.deviceInfo.batteryDiscription)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(entry.date, style: .time)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct InlineWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: entry.deviceInfo.getBattrySymbole())
                .imageScale(.large)
            Text(entry.deviceInfo.batteryLevel.toPercentString())
        }
    }
}

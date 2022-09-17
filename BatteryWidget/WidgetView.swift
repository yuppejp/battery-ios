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
            RingProgressView(value: Double(entry.batteryLevel))
            VStack {
                Image(systemName: "iphone")
                    .imageScale(.large)
                //Text(entry.batteryLevel, format: FloatingPointFormatStyle.Percent())
                //    .font(.title)
                Text(entry.batteryLevel.percentString)
                    .font(.title)
                Text(entry.date, style: .time)
                    .font(.caption)
            }
        }
        .padding(12)
    }
}

struct CircularWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            RingProgressView(value: Double(entry.batteryLevel), lineWidth: 6.0)
            VStack {
                Image(systemName: "iphone")
                    .imageScale(.medium)
                Text(entry.batteryLevel.percentString)
                    .font(.caption2)
            }
        }
    }
}

struct RectangularWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            ZStack {
                RingProgressView(value: Double(entry.batteryLevel), lineWidth: 6.0)
                VStack {
                    Image(systemName: "iphone")
                        .imageScale(.large)
                }
            }
            VStack {
                Text(entry.batteryLevel.percentString)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(entry.discription)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            Image(systemName: "iphone")
                .imageScale(.large)
            Text(entry.batteryLevel.percentString)
                .font(.caption)
        }
    }
}

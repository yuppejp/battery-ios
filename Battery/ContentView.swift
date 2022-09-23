//
//  ContentView.swift
//  Battery
//
//  Created on 2022/09/17.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State var circleSize = CGSize()
    @ObservedObject var deviceInfo = DeviceInfo()

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RingProgressView(value: Double(deviceInfo.batteryLevel),
                                 systemName: deviceInfo.batteryState == .charging ? "bolt.fill" : "")
                    .background(GeometryReader{ geometry -> Text in
                        DispatchQueue.main.async {
                            circleSize = geometry.size
                        }
                        return Text("")
                    })
                VStack {
                    Image(systemName: "iphone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: circleSize.width / 6)

                    Text(deviceInfo.batteryLevel.toPercentString())
                        .font(.largeTitle)
                }
            }
            .padding(20)
            .padding(.top, circleSize.height / 20)

            List {
                Section {
                    ListItemView(name: Text("BatteryLevel"),
                                 value: Text(deviceInfo.batteryLevel.toDecimalString(minDigits: 2, maxDigits: 2)))
                    ListItemView(name: Text("BatteryStatus"),
                                 value: Text(deviceInfo.batteryDiscription))
                } header: {
                    Text("BatterySection")
                }
                Section {
                    ListItemView(name: Text("DeviceName"), value: Text(deviceInfo.deviceName))
                    ListItemView(name: Text("DeviceSystemVersion"), value: Text(deviceInfo.deviceSystemVersion))
                } header: {
                    Text("DeviceSection")
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                deviceInfo.update()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                deviceInfo.update()
            }
            
            // update nofification to widget
            WidgetCenter.shared.reloadTimelines(ofKind: "jp.yuupe.Battery.BatteryWidget")
            WidgetCenter.shared.reloadTimelines(ofKind: "jp.yuupe.Battery.BatteryWidget2")
        }
    }
}

struct ListItemView: View {
    var name: Text
    var value: Text

    var body: some View {
        HStack {
            name.frame(maxWidth: .infinity, alignment: .leading)
            value
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let localizationIds = ["en", "ja"]
    
    static var previews: some View {
        let deviceInfo = DeviceInfo(batteryLevel: 0.8, batteryState: .charging)
        
        ForEach(localizationIds, id: \.self) { id in
            ContentView(deviceInfo: deviceInfo)
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}

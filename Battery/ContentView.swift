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
    @State var batteryLevel: Float = 0.0
    @State var batteryState: UIDevice.BatteryState = .unknown
    @State var batteryDiscription: String = ""
    @State var deviceName = ""
    @State var deviceSystemVersion = ""

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RingProgressView(value: Double(batteryLevel))
                VStack {
                    Text(batteryLevel.toPercentString())
                        .font(.largeTitle)
                    HStack {
                        Image(systemName: getBattryIcon())
                            .imageScale(.large)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 1)
                }
            }
            .padding(20)
            
            List {
                Section {
                    ListItemView(name: Text("BatteryLevel"),
                                 //value: Text(batteryLevel, format: FloatingPointFormatStyle.Percent()))
                                 value: Text(batteryLevel.toDecimalString(minDigits: 2, maxDigits: 2)))
                    ListItemView(name: Text("BatteryStatus"),
                                 value: Text(batteryDiscription))
                } header: {
                    Text("BatterySection")
                }
                Section {
                    ListItemView(name: Text("DeviceName"), value: Text(deviceName))
                    ListItemView(name: Text("DeviceSystemVersion"), value: Text(deviceSystemVersion))
                } header: {
                    Text("DeviceSection")
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                getBatteryStatus()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                getBatteryStatus()
            }
            
            // update nofification to widget
            WidgetCenter.shared.reloadTimelines(ofKind: "jp.yuupe.Battery.BatteryWidget")
            //WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func getBatteryStatus() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevel = UIDevice.current.batteryLevel
        batteryState = UIDevice.current.batteryState
        deviceName = UIDevice.current.name
        deviceSystemVersion = UIDevice.current.systemVersion
        UIDevice.current.isBatteryMonitoringEnabled = false

        // debug
        //if batteryLevel == -1 {
        //    batteryLevel = 0.8
        //    batteryState = .charging
        //}

        switch batteryState {
        case .unknown: batteryDiscription = NSLocalizedString("BatteryState.unknown", comment: "")
        case .unplugged: batteryDiscription = NSLocalizedString("BatteryState.unplugged", comment: "")
        case .charging: batteryDiscription = NSLocalizedString("BatteryState.charging", comment: "")
        case .full: batteryDiscription = NSLocalizedString("BatteryState.full", comment: "")
        default:  batteryDiscription = NSLocalizedString("BatteryState.default", comment: "")
        }
    }
    
    func getBattryIcon() -> String {
        if batteryState == .charging {
            return "battery.100.bolt"
        } else {
            if batteryLevel < 0.1 {
                return "battery.0"
            } else if batteryLevel < 0.5 {
                return "battery.25"
            } else if batteryLevel < 0.75 {
                return "battery.50"
            } else if batteryLevel < 0.95 {
                return "battery.75"
            } else {
                return "battery.100"
            }
         }
    }
    
}

struct ListItemView: View {
    var name: Text
    var value: Text

    var body: some View {
        HStack {
            name
                .frame(maxWidth: .infinity, alignment: .leading)
            value
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let localizationIds = ["en", "ja"]
    
    static var previews: some View {
        ForEach(localizationIds, id: \.self) { id in
            ContentView(batteryLevel: 0.3, batteryState: .unplugged)
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}

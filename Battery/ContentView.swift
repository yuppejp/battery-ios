//
//  ContentView.swift
//  Battery
//
//  Created on 2022/09/17.
//

import SwiftUI

struct ContentView: View {
    @State var batteryLevel: Float = 0.0
    @State var batteryState: UIDevice.BatteryState = .unknown
    @State var batteryDiscription: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RingProgressView(value: Double(batteryLevel))
                VStack {
                    Image(systemName: "iphone")
                        .imageScale(.large)
                        .foregroundColor(.green)
                    Text(batteryLevel, format: FloatingPointFormatStyle.Percent())
                        .font(.largeTitle)
                }
            }
            .padding()

            List {
                ListItemView(name: Text("Battery Level"),
                             //value: Text(batteryLevel, format: FloatingPointFormatStyle.Percent()))
                             value: Text(batteryLevel.percentString))
                ListItemView(name: Text("Battery Status"),
                             value: Text(batteryDiscription))
            }
        }
        .onAppear {
            UIDevice.current.isBatteryMonitoringEnabled = true
            batteryLevel = UIDevice.current.batteryLevel
            batteryState = UIDevice.current.batteryState
            UIDevice.current.isBatteryMonitoringEnabled = false
            
            // debug
            if batteryLevel == -1 {
                batteryLevel = 0.8
                batteryState = .charging
            }
            
            switch batteryState {
            case .unknown: batteryDiscription = "unknown"
            case .unplugged: batteryDiscription = "unplugged"
            case .charging: batteryDiscription = "charging"
            case .full: batteryDiscription = "full"
            default:  batteryDiscription = "error"
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
    static var previews: some View {
        ContentView()
    }
}

//
//  DeviceInfo.swift
//  Battery
//  
//  Created on 2022/09/23
//  


import Foundation
import UIKit

class DeviceInfo: ObservableObject {
    @Published var deviceName: String = ""
    @Published var deviceSystemVersion: String = ""
    @Published var batteryLevel: Float = 0.0
    @Published var batteryState: UIDevice.BatteryState = .unknown
    var batteryDiscription: String {
        let discription: String
        switch batteryState {
        case .unknown: discription = NSLocalizedString("BatteryState.unknown", comment: "")
        case .unplugged: discription = NSLocalizedString("BatteryState.unplugged", comment: "")
        case .charging: discription = NSLocalizedString("BatteryState.charging", comment: "")
        case .full: discription = NSLocalizedString("BatteryState.full", comment: "")
        default:  discription = NSLocalizedString("BatteryState.default", comment: "")
        }
        return discription
    }

    init() {
        update()
    }

    init(batteryLevel: Float, batteryState: UIDevice.BatteryState) {
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
    }

    func update() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevel = UIDevice.current.batteryLevel
        batteryState = UIDevice.current.batteryState
        deviceName = UIDevice.current.name
        deviceSystemVersion = UIDevice.current.systemVersion
        UIDevice.current.isBatteryMonitoringEnabled = false

        // debug
        //batteryLevel = 0.8
        //batteryState = .charging
    }

    func getBattrySymbole() -> String {
//        if batteryState == .charging {
//            return "battery.100.bolt"
//        }
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

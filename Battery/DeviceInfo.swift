//
//  DeviceInfo.swift
//  Battery
//  
//  Created on 2022/09/23
//  


import Foundation
import UIKit
import WidgetKit

class DeviceInfo: ObservableObject {
    @Published var deviceName: String = ""
    @Published var deviceSystemVersion: String = ""
    @Published var batteryLevel: Float = 0.0
    @Published var batteryState: UIDevice.BatteryState = .unknown
    var battrySymbole: String {
        return DeviceInfo.getBattrySymbole(batteryLevel, batteryState)
    }
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
    var nofificationOfKind: String?
    var refreshDate: Date = Date()
    
    init(monitoring: Bool = false, widgetOfKind: String? = nil) {
        self.nofificationOfKind = widgetOfKind
        
        refresh()
        
        if monitoring {
            startMonitoring()
        }
    }
    
    init(batteryLevel: Float, batteryState: UIDevice.BatteryState) {
        // for debug
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
    }
    
    deinit {
        stopMonitoring()
    }
    
    func refresh() {
        let monitoring = UIDevice.current.isBatteryMonitoringEnabled
        if monitoring == false {
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        
        batteryLevel = UIDevice.current.batteryLevel
        batteryState = UIDevice.current.batteryState
        deviceName = UIDevice.current.name
        deviceSystemVersion = UIDevice.current.systemVersion

        if monitoring == false {
            UIDevice.current.isBatteryMonitoringEnabled = false
        }

        refreshDate = Date()

#if targetEnvironment(simulator)
        batteryLevel = 0.8
        batteryState = .charging
#endif
    }
    
    func startMonitoring() {
        if UIDevice.current.isBatteryMonitoringEnabled {
            return
        }

        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChanged(notification:)),
            name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChanged(notification:)),
            name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    func stopMonitoring() {
        if UIDevice.current.isBatteryMonitoringEnabled == false {
            return
        }

        UIDevice.current.isBatteryMonitoringEnabled = false
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc func batteryLevelDidChanged(notification: Notification) {
        let level = UIDevice.current.batteryLevel
        if level != batteryLevel {
            batteryLevel = level
            refreshDate = Date()
            
            if let kind = nofificationOfKind {
                WidgetCenter.shared.reloadTimelines(ofKind: kind)
            }
        }
    }
    
    @objc func batteryStateDidChanged(notification: Notification) {
        let stat = UIDevice.current.batteryState
        if stat != batteryState {
            batteryState = stat
            refreshDate = Date()

            if let kind = nofificationOfKind {
                WidgetCenter.shared.reloadTimelines(ofKind: kind)
            }
        }
    }

    static func getBattrySymbole(_ level: Float, _ state: UIDevice.BatteryState) -> String {
        if state == .charging {
            return "battery.100.bolt"
        }
        
        if level <= 0.1 {
            return "battery.0"
        } else if level <= 0.25 {
            return "battery.25"
        } else if level <= 0.5 {
            return "battery.50"
        } else if level <= 0.95 {
            return "battery.75"
        } else {
            return "battery.100"
        }
    }
}

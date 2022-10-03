//
//  AppSettingView.swift
//  Battery
//
//  Created by yukio on 2022/10/01.
//

import SwiftUI

struct AppSettingView: View {
    @ObservedObject var appSetting: AppSetting
    
    var body: some View {
        Form {
            Section(header: Text("SettingGeneral")) {
                Picker(selection: $appSetting.useCircle, label: Text("SettingCircleType")) {
                    Text("SettingCircleType_Meter").tag(false)
                    Text("SettingCircleType_Circle").tag(true)
                }

                Picker(selection: $appSetting.useGreen, label: Text("SettingMeterColor")) {
                    Text("SettingMeterColor_Blue").tag(false)
                    Text("SettingMeterColor_Green").tag(true)
                }
                Picker(selection: $appSetting.useBatterySymbole, label: Text("SettingIconType")) {
                    Text("SettingIconType_Battery").tag(true)
                    Text("SettingIconType_Iphone").tag(false)
                }
            }

            Section(header: Text("SettingWidget")) {
                Toggle("SettingWidget_ShowIcon", isOn : $appSetting.showIcon)
                Toggle("SettingWidget_ShowTime", isOn : $appSetting.showDetectionTime)
            }
        }
    }
}

struct AppSettingView_Previews: PreviewProvider {
    static let localizationIds = ["en", "ja"]

    static var previews: some View {
        ForEach(localizationIds, id: \.self) { id in
            AppSettingView(appSetting: AppSetting())
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }

    }
}

// Widgetkit cannot use @AppStrage, so use UserDefaults
class AppSetting: ObservableObject {
    private let userDefaults = UserDefaults(suiteName: "group.com.yuppejp.battery")

    @Published var useCircle: Bool {
        didSet {
            userDefaults!.set(useCircle, forKey: "useCircle")
        }
    }
    
    @Published var useGreen: Bool {
        didSet {
            userDefaults!.set(useGreen, forKey: "useGreen")
        }
    }

    @Published var useBatterySymbole: Bool {
        didSet {
            userDefaults!.set(useBatterySymbole, forKey: "useBatterySymbole")
        }
    }

    @Published var showIcon: Bool {
        didSet {
            userDefaults!.set(showIcon, forKey: "showIcon")
        }
    }

    @Published var showDetectionTime: Bool {
        didSet {
            userDefaults!.set(showDetectionTime, forKey: "showDetectionTime")
        }
    }

    init() {
        userDefaults!.register(defaults: ["useCircle": false,
                                          "useGreen": false,
                                          "useBatterySymbole": true,
                                          "showIcon": true,
                                          "showDetectionTime": false])
        
        useCircle = userDefaults!.bool(forKey: "useCircle")
        useGreen = userDefaults!.bool(forKey: "useGreen")
        useBatterySymbole = userDefaults!.bool(forKey: "useBatterySymbole")
        showIcon = userDefaults!.bool(forKey: "showIcon")
        showDetectionTime = userDefaults!.bool(forKey: "showDetectionTime")
    }
}

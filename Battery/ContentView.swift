//
//  ContentView.swift
//  Battery
//
//  Created on 2022/09/17.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @StateObject var deviceInfo = DeviceInfo(monitoring: true, widgetOfKind: "com.yuupejp.Battery.BatteryWidget")
    @StateObject var appSetting = AppSetting()

    var body: some View {
        NavigationView {
            MainView(deviceInfo: deviceInfo, appSetting: appSetting)
                .navigationBarTitleDisplayMode(.inline) // hide title region
                .navigationBarItems(trailing: NavigationLink(destination: AppSettingView(appSetting: appSetting)) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.gray)
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var deviceInfo: DeviceInfo
    @ObservedObject var appSetting = AppSetting()
    @State var value: Float = 0.0

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if appSetting.useCircle {
                    GeometryReader{ geometry in
                        ZStack {
                            RingProgressView(value: deviceInfo.batteryLevel,
                                             symboleName: deviceInfo.batteryState == .charging ? "bolt.fill" : "",
                                             useGreen: appSetting.useGreen)
                            VStack {
                                Image(systemName: appSetting.useBatterySymbole ?  deviceInfo.battrySymbole : "iphone")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.height / 6)
                                Text(deviceInfo.batteryLevel.toPercentString())
                                    .font(.system(size: geometry.size.height / 6))
                            }
                        }
                    }
                } else {
                    GeometryReader{ geometry in
                        ZStack {
                            ArcProgressView(value: value,
                                            symboleName: deviceInfo.battrySymbole,
                                            useGreen: appSetting.useGreen)
                            Text(deviceInfo.batteryLevel.toPercentString())
                                .font(.system(size: geometry.size.height / 4))
                                .offset(y: -(geometry.size.height / 14))
                            
                            HStack {
                                Text("0")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .offset(x: -(geometry.size.height * 0.2))

                                Image(systemName: appSetting.useBatterySymbole ?  deviceInfo.battrySymbole : "iphone")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.height / 4,
                                           height: geometry.size.height / 4)
                                Text("100")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: geometry.size.height * 0.18)
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .offset(y: -(geometry.size.height / 25))
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    value = deviceInfo.batteryLevel
                }
            }
            .onChange(of: deviceInfo.batteryLevel) { newValue in
                withAnimation(.easeOut(duration: 0.5)) {
                    value = newValue
                }
            }
            .onChange(of: scenePhase) { phase in
    //            if phase == .active {
    //                deviceInfo.update()
    //            }
                
                // nofification to widget
                WidgetCenter.shared.reloadTimelines(ofKind: "com.yuupejp.Battery.BatteryWidget")
            }

            
            List {
                Section {
                    ListItemView(name: Text("BatteryLevel"),
                                 value: Text(deviceInfo.batteryLevel.toDecimalString(minDigits: 2, maxDigits: 2)))
                    ListItemView(name: Text("BatteryStatus"),
                                 value: Text(deviceInfo.batteryDiscription))
                    ListItemView(name: Text("RefreshTime"),
                                 value: Text(deviceInfo.refreshDate, style: .time))
                    ListItemView(name: Text("RefreshTimeOffset"),
                                 value: Text(deviceInfo.refreshDate, style: .offset))
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
            .padding(.top, 0)
        }
        //        .onChange(of: scenePhase) { phase in
        //            if phase == .active {
        //                deviceInfo.update()
        //            }
        //
        //            // update nofification to widget
        //            WidgetCenter.shared.reloadTimelines(ofKind: "com.yuupejp.Battery.BatteryWidget")
        //        }
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
        ForEach(localizationIds, id: \.self) { id in
            ContentView()
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
